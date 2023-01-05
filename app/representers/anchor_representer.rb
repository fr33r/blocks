# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class AnchorRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :name
  property :description
  # ids, not objects.
  collection :column_ids
end
