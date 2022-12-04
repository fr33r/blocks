# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class RowCollectionRepresenter < Roar::Decorator
  include Representable::JSON::Collection

  items class: Row do
    property :id
    property :data_hash, as: :hash
    property :data
  end
end
