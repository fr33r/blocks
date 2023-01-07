# frozen_string_literal: true

class AnchorTableComponent < ViewComponent::Base
  def initialize(anchors:)
    @anchors = anchors
  end
end
