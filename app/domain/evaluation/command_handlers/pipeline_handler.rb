# frozen_string_literal: true

module Evaluation
  module CommandHandlers
    class PipelineHandler < ::CommandHandlers::Handler
      private
      
      def with_pipeline(id, &block)
        repository.with_aggregate(Pipeline.new(id), stream_name(id), &block)
      end

      def stream_name(id)
        "#{Pipeline.to_s}$#{id}"
      end
    end
  end
end
