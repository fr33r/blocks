# frozen_string_literal: true

module Data
  module CommandHandlers
    class RowHandler < ::CommandHandlers::Handler
      private

      def with(entity, id, &block)
        repository.with_aggregate(entity, stream_name(entity.class, id), &block)
      end

      def with_row(id, &block)
        with(Row.new(id), id, &block)
      end

      def with_file(id, &block)
        with(File.new(id), id, &block)
      end

      def with_format(id, &block)
        with(FileFormat.new(id), id, &block)
      end

      def load(entity, id)
        repository.load(entity, stream_name(entity.class, id))
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

      def stream_name(entity_class, id)
        "#{entity_class}$#{id}"
      end
    end
  end
end
