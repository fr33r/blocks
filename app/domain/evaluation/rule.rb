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

    STATES = [State::ACTIVE, State::INACTIVE].freeze
    TYPES = [Type::FILTER, Type::VALIDATION].freeze

    class InvalidExecution < StandardError
    end

    attr_reader :id
    attr_reader :type
    attr_reader :state
    attr_reader :condition
    attr_reader :name
    attr_reader :description
    attr_reader :pipeline_id
    attr_reader :template
    attr_reader :created_at
    attr_reader :created_by
    attr_reader :updated_at
    attr_reader :updated_by
    
    def initialize(kwargs)
      @id = kwargs.fetch(:id, SecureRandom.uuid)
      @state = kwargs.fetch(:state, State::INACTIVE)
      @type = kwargs.fetch(:type)
      @condition = kwargs.fetch(:condition)
      @name = kwargs.fetch(:name)
      @pipeline_id = kwargs.fetch(:pipeline_id)
      @description = kwargs.fetch(:description)
      @template_id = kwargs.fetch(:template_id, nil)
      @created_by = kwargs.fetch(:created_by)
      @created_at = kwargs.fetch(:created_at, Time.now)
      @updated_by = kwargs.fetch(:updated_by, @created_by)
      @updated_at = kwargs.fetch(:updated_at, Time.now)
    end

    def inactive?
      state == State::INACTIVE
    end

    def active?
      state == State::ACTIVE
    end

    def update(name:, description:, updated_by:)
      @name = name
      @description = description
      @updated_by = updated_by
    end

    def activate(updated_by:, updated_at: Time.now)
      @updated_by = updated_by
      @updated_at = updated_at
      @state = State::ACTIVE
    end

    def inactivate(updated_by:, updated_at: Time.now)
      @updated_by = updated_by
      @updated_at = updated_at
      @state = State::INACTIVE
    end

    def match?(row)
      JSONLogic.apply(condition, row.data)
    end

    def filter?
      type == Type::FILTER
    end

    def validation?
      type == Type::VALIDATION
    end

    def execute!(row)
      fail InvalidExecution.new('cannot execute inactive rule') if inactive?

      matched = match?(row)
      if match
        if filter?
          # maybe want to think of a way to pass along which rule filtered the row?
          row.filter
          return
        end

        if validation?
          return Row::Error.new(failure_message, self.id)
        end
      end
    end
  end
end
