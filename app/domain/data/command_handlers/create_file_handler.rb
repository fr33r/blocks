# frozen_string_literal: true

module Data
  module CommandHandlers
    class CreateFileHandler < FileHandler
      def call(command)
        format = load_format(command.format_id)
        return if format.nil? # perhaps throw an error!

        with_file(command.id) do |f|
          f.upload(
            filename: command.filename,
            total_row_count: command.total_row_count,
            format_id: command.format_id,
          )
        end
      end
    end
  end
end
