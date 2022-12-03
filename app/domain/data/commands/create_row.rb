# frozen_string_literal: true

module Data
  module Commands
    class CreateRow
      attr_reader :id
      attr_reader :row_data
      attr_reader :created_by

      def initialize(id, row_data, created_by)
        @id = id
        @row_data = row_data
        @created_by = created_by
      end
    end
  end
end
