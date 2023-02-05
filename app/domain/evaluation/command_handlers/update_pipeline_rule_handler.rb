# frozen_string_literal: true

module Evaluation
  module CommandHandlers
    class UpdatePipelineRuleHandler < PipelineHandler
      def call(command)
        with_pipeline(command.pipeline_id) do |pipeline|
          pipeline.update_rule(
            rule_id: command.id,
            name: command.name,
            description: command.description,
            updated_by: command.updated_by,
          )
        end
      end
    end
  end
end
