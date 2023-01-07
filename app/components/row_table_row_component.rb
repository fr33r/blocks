# frozen_string_literal: true

class RowTableRowComponent < ViewComponent::Base
  def initialize(row:, show_actions:)
    @row = row
    @show_actions = show_actions
  end
end
