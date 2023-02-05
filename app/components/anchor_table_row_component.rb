# frozen_string_literal: true

class AnchorTableRowComponent < ViewComponent::Base
  def initialize(anchor:)
    @anchor = anchor
  end
end
