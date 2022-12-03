# frozen_string_literal: true

class Row < ApplicationRecord

  # validations.
  enum state: Data::Row::STATES, _suffix: true
  
  # scopes.
  scope :with_hash, ->(hash) { where(hash: hash) }
end
