# frozen_string_literal: true

module Data
  module Commands
    class CreateFile
      include ActiveModel::Validations

      attr_accessor :id
      attr_accessor :format_id
      attr_accessor :filename
      attr_accessor :total_row_count
      attr_accessor :created_by

      validates_presence_of :id
      validates_presence_of :format_id
      validates_presence_of :filename
      validates_presence_of :total_row_count
      validates_presence_of :created_by

      def initialize(id, format_id, filename, total_row_count, created_by)
        @id = id
        @format_id = format_id
        @filename = filename
        @total_row_count = total_row_count
        @created_by = created_by
      end
    end
  end
end
