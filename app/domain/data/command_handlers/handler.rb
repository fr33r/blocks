# frozen_string_literal: true

module Data
  module CommandHandlers
    class Handler < ::CommandHandlers::Handler
      private

      def with_row(id, &block)
        with(Row.new(id), id, &block)
      end

      def with_file(id, &block)
        with(File.new(id), id, &block)
      end

      def with_format(id, &block)
        with(FileFormat.new(id), id, &block)
      end

      def load_format(id)
        self.load(FileFormat.new(id), id)
      end

      def load_file(id)
        self.load(File.new(id), id)
      end

      def load_row(id)
        self.load(Row.new(id), id)
      end
    end
  end
end
