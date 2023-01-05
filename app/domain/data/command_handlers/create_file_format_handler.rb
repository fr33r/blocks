# frozen_string_literal: true

module Data
  module CommandHandlers
    class CreateFileFormatHandler < FileFormatHandler
      def call(cmd)
        with_format(cmd.id) do |f|
          f.create(cmd.name, cmd.columns_args, cmd.anchors_args, cmd.created_by)
        end
      end
    end
  end
end
