# frozen_string_literal: true

class EventTableComponent < ViewComponent::Base
  def initialize(events:)
    @events = events
  end
end
