# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class PipelineCollectionRepresenter < Roar::Decorator
  include Representable::JSON::Collection

  items class: Pipeline do
    property :id
    collection :rules, extends: RuleRepresenter, class: Rule
    property :created_at
    property :updated_at
  end
end
