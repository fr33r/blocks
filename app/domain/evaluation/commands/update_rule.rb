# frozen_string_literal: true

module Evaluation 
  module Commands
    class UpdateRule
      attr_reader :id
      attr_reader :type
      attr_reader :condition
      attr_reader :name
      attr_reader :description
      attr_reader :pipeline_id
      attr_reader :created_at
      attr_reader :created_by
      attr_reader :updated_at
      attr_reader :updated_by
      attr_reader :data

      def initialize(args)
        @id = args.fetch('id')
        @type = args.fetch('type')
        @condition = args.fetch('condition')
        @name = args.fetch('name')
        @description = args.fetch('description')
        @template_id = args.fetch('template_id', nil)
        @pipeline_id = args.fetch('pipeline_id')
        @created_by = args.fetch('created_by')
        @created_at = args.fetch('created_at')
        @updated_by = created_by
        @updated_at = created_at
        @data = args.symbolize_keys
      end
    end
  end
end
