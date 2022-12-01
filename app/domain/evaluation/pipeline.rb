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
      event_data = { created_at: Time.now }
      apply Events::PipelineCreated.new(data: event_data)
    end

    def execute(row)
      rules.each { |rule| rule.execute(row) }
    end
  end
end
