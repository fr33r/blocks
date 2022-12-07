# frozen_string_literal: true

class RowTableRowComponent < ViewComponent::Base
  def initialize(row:)
    @row = row
  end
end
