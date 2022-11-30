# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class RowRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :state
  property :hash
  property :data
  property :uploaded_at
  property :ingested_at
  property :filtered_at
end
