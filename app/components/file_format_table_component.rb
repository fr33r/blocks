# frozen_string_literal: true

class FileFormatTableComponent < ViewComponent::Base
  def initialize(formats:)
    @formats = formats
  end
end
