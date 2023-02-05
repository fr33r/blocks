# frozen_string_literal: true

class FileFormatTableComponent < ViewComponent::Base
  def initialize(formats:, show_actions: true)
    @formats = formats
    @show_actions = show_actions
  end
end
