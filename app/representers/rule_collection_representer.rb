# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class RuleCollectionRepresenter < Roar::Decorator
  include Representable::JSON::Collection

  items class: Rule do
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
end

