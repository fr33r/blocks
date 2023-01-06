# frozen_string_literal: true

class ProcessedStatusPillComponent < ViewComponent::Base
  attr_reader :state
  attr_reader :description

  def initialize(entity_class:)
    @state = 'PROCESSED'
    @description = "The #{entity_class.to_s.underscore.humanize} has been successfully processed."
  end
end
