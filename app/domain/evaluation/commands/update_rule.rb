# frozen_string_literal: true

module Data
  module Commands
    class UpdateRule
      attr_reader :id
      attr_reader :type
      attr_reader :condition
      attr_reader :name
      attr_reader :description
      attr_reader :template
      attr_reader :created_at
      attr_reader :created_by
      attr_reader :updated_at
      attr_reader :updated_by

      def initialize(kwargs)
        @id = kwargs.fetch(:id) || SecureRandom.uuid
        @type = kwargs.fetch(:type)
        @condition = kwargs.fetch(:condition)
        @name = kwargs.fetch(:name)
        @description = kwargs.fetch(:description)
        @template_id = kwargs.fetch(:template_id)
        @created_by = kwargs.fetch(:created_by)
        @created_at = kwargs.fetch(:created_at) || Time.now
        @updated_by = kwargs.fetch(:updated_by)
        @updated_at = kwargs.fetch(:updated_at) || Time.now
      end
    end
  end
end
