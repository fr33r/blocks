# frozen_string_literal: true

module Data
  module CommandHandlers
    class CreateFileFormatHandler < FileFormatHandler
      def call(command)
        with_format(command.id) do |f|
          f.create(command.name, command.created_by)
        end
      end
    end
  end
end
