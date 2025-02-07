# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class RowRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :state
  property :data_hash, as: :hash
  property :data
  collection :errors, extend: RowErrorRepresenter, class: RowError
  property :uploaded_at
  property :uploaded_by
  property :updated_at
  property :updated_by
  collection :anchor_values, extend: AnchorValueRepresenter
end
