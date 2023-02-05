# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class RowErrorRepresenter < Roar::Decorator
  include Roar::JSON

  property :message
  property :rule_id
  property :created_at
  property :created_by
end
