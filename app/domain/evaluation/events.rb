# frozen_string_literal: true

module Evaluation
  module Events
    # ====== RULE ====== #

    # Domain event that occurs when the rule is created.
    class PipelineRuleCreated < RailsEventStore::Event; end
    # Domain event that occurs when the rule is activated.
    class PipelineRuleActivated < RailsEventStore::Event; end
    # Domain event that occurs when the rule is inactivated.
    class PipelineRuleInactivated < RailsEventStore::Event; end
    # Domain event that occurs when the rule is updated.
    class PipelineRuleUpdated < RailsEventStore::Event; end

    # ====== PIPELINE ====== #

    # Domain event that occurs when the pipeline is created.
    class PipelineCreated < RailsEventStore::Event; end
    # Domain event that occurs when the pipeline is activated.
    class PipelineActivated < RailsEventStore::Event; end
    # Domain event that occurs when the pipeline is inactivated.
    class PipelineInactivated < RailsEventStore::Event; end

    # ====== CONSTANTS ====== #
    ALL = [
      PipelineRuleCreated,
      PipelineRuleActivated,
      PipelineRuleInactivated,
      PipelineRuleUpdated,
      PipelineCreated,
    ]
  end
end
