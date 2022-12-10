# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class RuleRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :state
  property :type
  property :condition
  property :name
  property :description
  property :template_id
  property :created_at
  property :created_by
  property :updated_at
  property :updated_by
end

