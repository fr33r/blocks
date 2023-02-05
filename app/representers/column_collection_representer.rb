# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class ColumnCollectionRepresenter < Roar::Decorator
  include Representable::JSON::Collection

  items class: Column do
    property :id
    property :name
    property :description
    property :required
    property :data_type
  end
end
