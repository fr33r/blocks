# frozen_string_literal: true

module Evaluation
  module CommandHandlers
    class ActivatePipelineRuleHandler < PipelineHandler
      def call(command)
        with_pipeline(command.pipeline_id) do |pipeline|
          pipeline.activate_rule(rule_id: command.id, updated_by: command.updated_by)
        end
      end
    end
  end
end
