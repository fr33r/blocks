# frozen_string_literal: true

class RowTableComponent < ViewComponent::Base
  def initialize(rows:, show_actions: true)
    @rows = rows
    @show_actions = show_actions
  end
end
