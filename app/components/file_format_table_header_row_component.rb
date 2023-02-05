# frozen_string_literal: true

class FileFormatTableHeaderRowComponent < ViewComponent::Base
  def initialize(show_actions:)
    @show_actions = show_actions
  end
end
