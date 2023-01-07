# frozen_string_literal: true

class FileFormatTableRowComponent < ViewComponent::Base
  def initialize(format:)
    @format = format
  end
end
