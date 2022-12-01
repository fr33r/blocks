# frozen_string_literal: true

module Evaluation
  class Rule
    class Type
      FILTER     = :filter
      VALIDATION = :validation
    end

    class State
      ACTIVE   = :active
      INACTIVE = :inactive
    end

    class InvalidExecution < StandardError
    end

    attr_reader :id
    attr_reader :type
    attr_reader :state
    attr_reader :condition
    attr_reader :name
    attr_reader :description
    attr_reader :template
    attr_reader :activated_at
    attr_reader :inactivated_at
    attr_reader :created_by
    attr_reader :created_at
    attr_reader :updated_at
    attr_reader :updated_by
    
    def initialize(id)
      @id = id
    end

    def inactive?
      state == State::INACTIVE
    end

    def active?
      state == State::ACTIVE
    end

    def create(kwargs)
      kwargs[:created_at] = Time.now
      apply Events::RuleCreated.new(data: kwargs)
    end

    def activate(updated_by:)
      event_data = { updated_at: Time.now, activated_at: Time.now, updated_by: updated_by }
      apply Events::RuleActivated.new(data: event_data)

    def inactivate(updated_by:)
      event_data = { updated_at: Time.now, inactivated_at: Time.now, updated_by: updated_by }
      apply Events::RuleInactivated.new(data: event_data)
    end

    def execute(row)
      matched = JSONLogic.apply(condition, row.data)
      fail InvalidExecution.new('cannot execute inactive rule') if inactive?

      row.filter if matched && type == Type::FILTER
      if type == Type::VALIDATION
        matched ? row.validate : row.invalidate
      end
    end

    on Events::RuleCreated do |event|
      @state = State::INACTIVE
      @type = event.data.fetch(:type)
      @condition = event.data.fetch(:condition)
      @name = event.data.fetch(:name)
      @description = event.data.fetch(:description)
      @template = event.data.fetch(:template)
      @created_at = event.data.fetch(:created_at)
      @created_by = event.data.fetch(:created_by)
      @updated_at = created_at
      @updated_by = created_by
    end

    on Events::RuleActivated do |event|
      @state = State::ACTIVE
      @activated_at = event.data.fetch(:activated_at)
      @updated_at = event.data.fetch(:updated_at)
      @updated_by = event.data.fetch(:updated_by)
    end

    on Events::RuleInactivated do |event|
      @state = State::INACTIVE
      @inactivated_at = event.data.fetch(:inactivated_at)
      @updated_at = event.data.fetch(:updated_at)
      @updated_by = event.data.fetch(:updated_by)
    end
  end
end
