# frozen_string_literal: true

module CommandHandlers
  class Handler
    attr_reader :event_store

    def initialize(event_store)
      @event_store = event_store
    end

    def call(command)
      fail NotImplementedError
    end

    private

    def stream_name(id)
      fail NotImplementedError
    end

    def repository
      AggregateRoot::Repository.new(event_store)
    end
  end
end
