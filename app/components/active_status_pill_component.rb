# frozen_string_literal: true

class ActiveStatusPillComponent < ViewComponent::Base
  attr_reader :state
  attr_reader :description

  def initialize(entity_class:)
    @state = 'ACTIVE'
    @description = "The #{entity_class.to_s.underscore.humanize} is active."
  end
end
