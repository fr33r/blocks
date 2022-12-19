# frozen_string_literal: true

module Data
  module Commands
    class CreateRow
      attr_reader :id
      attr_reader :file_id
      attr_reader :row_number
      attr_reader :format_id
      attr_reader :row_data
      attr_reader :created_by

      def initialize(id, row_number, format_id, file_id, row_data, created_by)
        @id = id
        @row_number = row_number
        @format_id = format_id
        @file_id = file_id
        @row_data = row_data
        @created_by = created_by
      end
    end
  end
end
