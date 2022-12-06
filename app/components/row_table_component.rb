# frozen_string_literal: true

class RowTableComponent < ViewComponent::Base
  def initialize(rows:)
    @rows = rows
  end
end
