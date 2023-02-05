# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class PipelineRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :state
  collection :rules, extend: RuleRepresenter, class: Rule
  property :created_at
  property :created_by
  property :updated_at
  property :updated_by
end
