# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class FileCollectionRepresenter < Roar::Decorator
  include Representable::JSON::Collection

  items class: File do
    property :id
    property :state
    property :filename
    property :uploaded_at
  end
end
