# frozen_string_literal: true

class ValidStatusPillComponent < ViewComponent::Base
  attr_reader :state
  attr_reader :description

  def initialize
    @state = 'VALID'
    @description = 'The row has been evaluated and has passed all rules.'
  end
end
