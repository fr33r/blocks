# frozen_string_literal: true

module Data
  module Commands
    class CreateFileFormat
      include ActiveModel::Validations

      attr_accessor :id
      attr_accessor :name
      attr_accessor :created_by

      validates_presence_of :id
      validates_presence_of :name
      validates_presence_of :created_by

      def initialize(id, name, created_by)
        @id = id
        @name = name
        @created_by = created_by
      end
    end
  end
end
