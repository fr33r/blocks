# frozen_string_literal: true

class FileTableRowComponent < ViewComponent::Base
  def initialize(file:, show_actions: true)
    @file = file
    @show_actions = show_actions
  end
end
