# frozen_string_literal: true

class FileTableHeaderRowComponent < ViewComponent::Base
  def initialize(show_actions: true)
    @show_actions = show_actions
  end
end
