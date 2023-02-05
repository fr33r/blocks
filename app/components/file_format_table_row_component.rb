# frozen_string_literal: true

class FileFormatTableRowComponent < ViewComponent::Base
  def initialize(format:, show_actions:)
    @format = format
    @show_actions = show_actions
  end
end
