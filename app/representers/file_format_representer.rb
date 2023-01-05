# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

class FileFormatRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :state
  property :name
  # property :description
  # watch out! don't mispell decorator - silent semantic bug.
  collection :columns, decorator: ColumnRepresenter, wrap: false
  collection :anchors, decorator: AnchorRepresenter, wrap: false
end
