# frozen_string_literal: true

class InactiveStatusPillComponent < ViewComponent::Base
  attr_reader :state
  attr_reader :description

  def initialize(entity_class:)
    @state = 'INACTIVE'
    @description = "The #{entity_class.to_s.humanize} is inactive."
  end
end
