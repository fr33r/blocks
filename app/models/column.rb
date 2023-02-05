# frozen_string_literal: true

class Column < ApplicationRecord
  # associations.
  belongs_to :file_format
  has_and_belongs_to_many :anchors

  # enum values.
  DATA_TYPES = %i[integer decimal date datetime string]
  DATA_TYPE_ENUM_VALUES = DATA_TYPES.to_h { |type| [type, type.to_s] }

  # validations.
  enum data_type: DATA_TYPE_ENUM_VALUES, _suffix: true
  validates_presence_of :name
  validates :required, inclusion: { in: [ true, false ] }
end
