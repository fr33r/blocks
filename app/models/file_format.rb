# frozen_string_literal: true

class FileFormat < ApplicationRecord
  # associations.
  has_many :files, class_name: DataFile.to_s

  # enum values.
  STATE_ENUM_VALUES = Data::FileFormat::STATES.to_h { |state| [state, state.to_s] }

  # validations.
  enum state: STATE_ENUM_VALUES, _suffix: true
  validates_presence_of :name
end
