# frozen_string_literal: true

module Data
  module CommandHandlers
    class RowHandler < Handler
      def initialize(event_store)
        super(event_store)
      end

      private
      
      def with_row(id)
        Data::Row.new(id).tap do |row|
          load_row(id, row)
          yield(row)
          store_row(row)
        end
      end

      def load_row(id, row)
        row.load(stream_name(id), event_store: event_store)
      end

      def store_row(row)
        row.store(event_store: event_store)
      end

      def stream_name(id)
        "Row$#{id}"
      end
    end
  end
end
