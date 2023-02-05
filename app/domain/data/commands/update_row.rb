# frozen_string_literal: true

module Data
  module Commands
    class UpdateRow
      attr_reader :id
      attr_reader :row_data
      attr_reader :updated_by

      def initialize(id, row_data, updated_by)
        @id = id
        @row_data = row_data
        @updated_by = updated_by
      end
    end
  end
end
