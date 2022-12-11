# frozen_string_literal: true

module Evaluation
  module CommandHandlers
    class CreatePipelineHandler < PipelineHandler
      def call(command)
        with_pipeline(command.id) do |row|
          pipeline.create
        end
      end
    end
  end
end
