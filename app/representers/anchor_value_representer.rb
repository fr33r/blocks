# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class AnchorValueRepresenter < Roar::Decorator
  include Roar::JSON

  property :data
  property :anchor_id
  property :data_hash, as: :hash
end
