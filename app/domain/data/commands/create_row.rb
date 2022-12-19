# frozen_string_literal: true

module Data
  module Commands
    class CreateRow
      include ActiveModel::Validations

      attr_accessor :id
      attr_accessor :file_id
      attr_accessor :row_number
      attr_accessor :format_id
      attr_accessor :row_data
      attr_accessor :created_by

      validates_presence_of :id
      validates_presence_of :format_id
      validates_presence_of :file_id
      validates_presence_of :row_number
      validates_presence_of :row_data
      validates_presence_of :created_by

      def initialize(id, row_number, format_id, file_id, row_data, created_by)
        id = id
        row_number = row_number
        format_id = format_id
        file_id = file_id
        row_data = row_data
        created_by = created_by
      end
    end
  end
end
