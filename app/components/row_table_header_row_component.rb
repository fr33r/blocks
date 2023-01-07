# frozen_string_literal: true

class RowTableHeaderRowComponent < ViewComponent::Base
  def intialize(show_actions:)
    @show_actions = show_actions
  end
end
