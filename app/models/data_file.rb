# frozen_string_literal: true

class DataFile < ApplicationRecord
  # associations.
  belongs_to :file_format
  has_many :rows
  has_many :source_row_links, through: :rows
  has_many :target_row_links, through: :rows

  # enum values.
  STATE_ENUM_VALUES = Data::File::STATES.to_h { |state| [state, state.to_s] }

  # validations.
  enum state: STATE_ENUM_VALUES, _suffix: true
  validates_presence_of :filename
  validates_presence_of :total_row_count

  # aliases.
  alias_attribute :uploaded_at, :created_at
end
