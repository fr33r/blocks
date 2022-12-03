# frozen_string_literal: true

module Data
  module CommandHandlers
    class Handler
      attr_reader :event_store

      def initialize(event_store)
        @event_store = event_store
      end

      def call(command)
        fail NotImplementedError
      end
    end
  end
end
