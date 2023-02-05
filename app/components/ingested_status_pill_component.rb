# frozen_string_literal: true

class IngestedStatusPillComponent < ViewComponent::Base
  attr_reader :state
  attr_reader :description

  def initialize
    @state = 'INGESTED'
    @description = 'The row has been successfully ingested.'
  end
end
