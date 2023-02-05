# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class ColumnRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :name
  property :description
  property :required
  property :data_type
end
