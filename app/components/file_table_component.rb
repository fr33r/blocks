# frozen_string_literal: true

class FileTableComponent < ViewComponent::Base
  def initialize(files:, show_actions: true)
    @files = files
    @show_actions = show_actions
  end
end
