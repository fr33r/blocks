# frozen_string_literal: true

module Data
  module CommandHandlers
    class RowHandler < Handler
      def initialize(event_store)
        super(event_store)
      end

      private
      
      def with_row(id, &block)
        repository.with_aggregate(Row.new(id), stream_name(id), &block)
      end

      def stream_name(id)
        "Row$#{id}"
      end

      def repository
        AggregateRoot::Repository.new(event_store)
      end
    end
  end
end
