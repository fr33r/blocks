# frozen_string_literal: true

class Row < ApplicationRecord
  # enum values.
  STATE_ENUM_VALUES = Data::Row::STATES.to_h { |state| [state, state.to_s] }

  # validations.
  enum state: STATE_ENUM_VALUES, _suffix: true
  
  # scopes.
  scope :with_hash, ->(hash) { where(hash: hash) }

  # aliases.
  alias_attribute :uploaded_at, :created_at
  alias_attribute :uploaded_by, :created_by
end
