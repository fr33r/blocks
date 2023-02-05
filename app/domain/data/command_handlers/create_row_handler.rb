# frozen_string_literal: true

module Data
  module CommandHandlers
    class CreateRowHandler < RowHandler
      def call(command)
        format = load_format(command.format_id)
        return if format.nil? # perhaps throw an error!

        file = load_file(command.file_id)
        return if file.nil? # perhaps throw an error!

        with_row(command.id) do |r|
          r.upload(command.row_number, command.file_id, command.row_data, format)
        end

        row = load_row(command.id)
        return if row.nil?

        # indicate to the file that we have a uploaded a row.
        # since Data::File and Data::Row are separate aggregates, the relationship
        # between their invariants is eventually consistent / loosely coupled.
        with_file(command.file_id) do |f|
          f.process_row(row)
        end
      end
    end
  end
end
