# frozen_string_literal: true

module Evaluation
  module CommandHandlers
    class InactivatePipelineRuleHandler < PipelineHandler
      def call(command)
        with_pipeline(command.id) do |row|
          pipeline.inactivate_rule(rule_id: command.rule_id, updated_by: command.updated_by)
        end
      end
    end
  end
end
