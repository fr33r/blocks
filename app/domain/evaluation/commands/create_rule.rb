# frozen_string_literal: true

module Evaluation
  module Commands
    class CreateRule
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
      attr_reader :data

      def initialize(args)
        @id = args.fetch('id', SecureRandom.uuid)
        @type = args.fetch('type')
        @condition = args.fetch('condition')
        @name = args.fetch('name')
        @description = args.fetch('description')
        @template_id = args.fetch('template_id', nil)
        @created_by = args.fetch('created_by')
        @created_at = args.fetch('created_at', Time.now)
        @updated_by = created_by
        @updated_at = created_at
        @data = args.symbolize_keys.merge(id: @id, created_at: @created_at)
      end
    end
  end
end
