# frozen_string_literal: true

module Data
  module CommandHandlers
    class CreateRowHandler < RowHandler
      def call(command)
        with_row(command.id) do |row|
          row.upload(command.row_data)
        end
      end
    end
  end
end
