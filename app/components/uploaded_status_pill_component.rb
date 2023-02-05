# frozen_string_literal: true

class UploadedStatusPillComponent < ViewComponent::Base
  attr_reader :state
  attr_reader :description

  def initialize
    @state = 'UPLOADED'
    @description = 'The row has been uploaded but not yet evaluated.'
  end
end
