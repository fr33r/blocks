# frozen_string_literal: true

class ProcessingStatusPillComponent < ViewComponent::Base
  attr_reader :state
  attr_reader :description

  def initialize(entity_class:)
    @state = 'PROCESSING'
    @description = "The #{entity_class.to_s.underscore.humanize} is processing."
  end
end
