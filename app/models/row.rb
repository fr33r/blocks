# frozen_string_literal: true

class Row < ApplicationRecord
  # associations.
  has_many :row_errors
  belongs_to :file, class_name: DataFile.to_s

  # enum values.
  STATE_ENUM_VALUES = Data::Row::STATES.to_h { |state| [state, state.to_s] }

  # validations.
  enum state: STATE_ENUM_VALUES, _suffix: true
  
  # scopes.
  scope :with_hash, ->(hash) { where(data_hash: hash) }
  scope :with_state, ->(state) { where(state: state) }
  scope :with_data, lambda { |data|
    data_as_json = data.to_json
    where('? <@ data', data_as_json)
  }
  scope :with_id, ->(id) { where(id: id) }

  # aliases.
  alias_attribute :uploaded_at, :created_at
  alias_attribute :uploaded_by, :created_by
  alias_attribute :file_id, :data_file_id
end
