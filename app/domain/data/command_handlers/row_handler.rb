# frozen_string_literal: true

module Data
  module CommandHandlers
    class RowHandler < ::CommandHandlers::Handler
      private
      
      def with_row(id, &block)
        repository.with_aggregate(Row.new(id), stream_name(id), &block)
      end

      def stream_name(id)
        "#{Row.to_s}$#{id}"
      end
    end
  end
end
