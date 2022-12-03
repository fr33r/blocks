# frozen_string_literal: true

module Data
  module CommandHandlers
    class UpdateRowHandler < RowHandler
      def initialize(event_store)
        super(event_store)
      end

      def call(command)
        with_row(command.id) do |row|
          row.update_data(command.row_data)
        end
      end
    end
  end
end
