# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class FileFormatCollectionRepresenter < Roar::Decorator
  include Representable::JSON::Collection

  items class: FileFormat do
    property :id
    property :state
    property :name
    # property :created_at
  end
end

