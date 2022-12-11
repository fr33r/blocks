# frozen_string_literal: true

module Evaluation
  class Pipeline
    include AggregateRoot

    attr_reader :id
    attr_reader :rules
    attr_reader :created_at
    attr_reader :updated_at

    def initialize(id)
      @id = id
      @indexed_rules = {}
    end

    def create
      event_data = { created_at: Time.now, updated_at: Time.now }
      apply Events::PipelineCreated.new(data: event_data)
    end

    def create_rule(kwargs)
      rule = Rule.new(kwargs)
      event_data = {
        id: rule.id,
        state: rule.state,
        type: rule.type,
        condition: rule.condition,
        name: rule.name,
        description: rule.description,
        created_by: rule.created_by,
        created_at: rule.created_at,
        updated_by: rule.updated_by,
        updated_at: rule.updated_at,
      }
      apply Events::PipelineRuleCreated.new(data: event_data)
    end

    def activate_rule(rule_id:, updated_by:)
      event_data = { rule_id: rule_id, rule_updated_at: Time.now, rule_updated_by: updated_by }
      apply Events::PipelineRuleActivated.new(data: event_data)
    end

    def inactivate_rule(rule_id:, updated_by:)
      event_data = { rule_id: rule_id, rule_updated_at: Time.now, rule_updated_by: updated_by }
      apply Events::PipelineRuleInactivated.new(data: event_data)
    end

    def execute!(row)
      rules.map do |rule|
        rule.execute!(row)
      end
    end

    on Events::PipelineCreated do |event|
      @created_at = event.data.fetch(:created_at)
      @updated_at = event.data.fetch(:updated_at)
    end

    on Events::PipelineRuleCreated do |event|
      rule = Rule.new(event.data)
      @indexed_rules[rule.id] = rule
    end

    on Events::PipelineRuleActivated do |event|
      rule_updated_at = event.data.fetch(:updated_at)
      rule_updated_by = event.data.fetch(:updated_by)
      rule_id = event.data.fetch(:rule_id)
      @indexed_rules[rule_id].activate(updated_at: rule_updated_at, updated_by: rule_updated_by)
    end

    on Events::PipelineRuleInactivated do |event|
      rule_updated_at = event.data.fetch(:updated_at)
      rule_updated_by = event.data.fetch(:updated_by)
      rule_id = event.data.fetch(:rule_id)
      @indexed_rules[rule_id].inactivate(updated_at: rule_updated_at, updated_by: rule_updated_by)
    end
  end
end
