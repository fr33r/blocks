# frozen_string_literal: true

module Evaluation
  module Commands
    class CreatePipeline
      attr_reader :id
      attr_reader :created_at
      attr_reader :updated_at

      def initialize(kwargs)
        @id = kwargs.fetch(:id) || SecureRandom.uuid
        @created_at = kwargs.fetch(:created_at) || Time.now
        @updated_at = created_at
      end
    end
  end
end
