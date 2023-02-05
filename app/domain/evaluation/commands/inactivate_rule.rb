# frozen_string_literal: true

module Evaluation
  module Commands
    class InactivateRule
      attr_reader :id
      attr_reader :updated_at
      attr_reader :updated_by

      def initialize(id:, updated_by:, updated_at: Time.now)
        @id = id
        @updated_by = created_by
        @updated_at = created_at
      end
    end
  end
end
