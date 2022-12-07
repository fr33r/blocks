# frozen_string_literal: true

class InvalidStatusPillComponent < ViewComponent::Base
  attr_reader :state
  attr_reader :description

  def initialize
    @state = 'INVALID'
    @description = 'The row has been evaluated and has failed at least one rule.'
  end
end
