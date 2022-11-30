# frozen_string_literal: true

class FileFormatRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :state
  property :name
  property :description
  property :updated_at
  property :activated_at
  property :inactived_at
  collection :columns
end

