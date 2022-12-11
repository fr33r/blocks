# frozen_string_literal: true

module Evaluation
  module CommandHandlers
    class Configuration
      def self.call(event_store, command_bus)
        command_bus.register(Commands::CreatePipeline, CreatePipelineHandler.new(event_store))
        command_bus.register(Commands::CreateRule, CreatePipelineRuleHandler.new(event_store))
        command_bus.register(Commands::ActivateRule, ActivatePipelineRuleHandler.new(event_store))
        command_bus.register(Commands::InactivateRule, InactivatePipelineRuleHandler.new(event_store))
      end
    end
  end
end
