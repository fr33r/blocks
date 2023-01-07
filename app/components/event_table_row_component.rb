# frozen_string_literal: true

class EventTableRowComponent < ViewComponent::Base
  def initialize(event:)
    @event = event
  end
end
