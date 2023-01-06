# frozen_string_literal: true

class CreatedStatusPillComponent < ViewComponent::Base
  attr_reader :state
  attr_reader :description

  def initialize(entity_class:)
    @state = 'CREATED'
    @description = "The #{entity_class.to_s.humanize} has been created but not activated."
  end
end
