# frozen_string_literal: true

class PillComponent < ViewComponent::Base
  def initialize(state:)
    @state = state.upcase
    @color = color
    @description = description
    @text_color = text_color
  end

  def description
    case @state
    when 'uploaded'
      'The row has been uploaded but not yet evaluated.'
    when 'valid'
      'The row has been evaluated and has passed all rules.'
    when 'invalid'
      'The row has been evaluated and has failed at least one rule.'
    when 'filtered'
      'The row has been filtered.'
    when 'ingested'
      'The row has been successfully ingested.'
    end
  end

  def text_color
    'text-black'
  end

  def color
    case @state
    when 'uploaded'
      'bg-yellow-100'
    when 'valid'
      'bg-lime-100'
    when 'invalid'
      'bg-red-100'
    else
      'bg-neutral-300'
    end
  end
end
