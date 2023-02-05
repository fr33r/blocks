# frozen_string_literal: true

class FilteredStatusPillComponent < ViewComponent::Base
  attr_reader :state
  attr_reader :description

  def initialize
    @state = 'FILTERED'
    @description = 'The row has been filtered.'
  end
end
