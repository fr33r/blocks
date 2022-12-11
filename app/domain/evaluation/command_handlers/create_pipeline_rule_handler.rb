# frozen_string_literal: true

module Evaluation
  module CommandHandlers
    class CreatePipelineRuleHandler < PipelineHandler
      def call(command)
        with_pipeline(command.id) do |pipeline|
          pipeline.create_rule(command.data)
        end
      end
    end
  end
end
