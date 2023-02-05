# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class FileRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :state
  property :filename
  property :uploaded_at
  property :processing_started_at
  property :processing_ended_at
end

