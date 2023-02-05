# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class AnchorCollectionRepresenter < Roar::Decorator
  include Representable::JSON::Collection

  items class: Anchor do
    property :id
    property :name
    property :description
    # ids, not objects.
    collection :columns
  end
end
