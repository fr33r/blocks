# frozen_string_literal: true

module Evaluation
  class Pipeline
    include AggregateRoot

    attr_reader :id
    attr_reader :rules
    attr_reader :created_at

    def initialize(id)
      @id = id
    end

    def create
      event_data = { created_at: Time.now, updated_at: Time.now }
      apply Events::PipelineCreated.new(data: event_data)
    end

    def create_rule(kwargs)
      rule = Rule.new(kwargs)
      apply Events::PipelineRuleCreated.new(data: { rule: rule } )
    end

    def activate_rule(rule_id:, updated_by:)
      event_data = { rule_id: rule_id, rule_updated_at: Time.now, rule_updated_by: updated_by }
      apply Events::PipelineRuleActivated.new(data: event_data)

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
      @created_at = event.fetch(:created_at)
      @updated_at = event.fetch(:updated_at)
    end

    on Events::PipelineRuleCreated do |event|
      rule_data = event_data.fetch(:rule)
      rule = Rule.new(rule_data)
      @rule[rule.id] = rule
    end

    on Events::PipelineRuleActivated do |event|
      rule_updated_at = event.data.fetch(:updated_at)
      rule_updated_by = event.data.fetch(:updated_by)
      rule_id = event.data.fetch(:rule_id)
      @rule[rule_id].activate(updated_at: rule_updated_at, updated_by: rule_updated_by)
    end

    on Events::PipelineRuleInactivated do |event|
      rule_updated_at = event.data.fetch(:updated_at)
      rule_updated_by = event.data.fetch(:updated_by)
      rule_id = event.data.fetch(:rule_id)
      @rule[rule_id].inactivate(updated_at: rule_updated_at, updated_by: rule_updated_by)
    end
  end
end
