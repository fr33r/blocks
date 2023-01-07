# frozen_string_literal: true

class AnchorValue < ApplicationRecord
  # associations.
  belongs_to :row
  belongs_to :anchor

  # validations.
  validates_presence_of :data
  validates_presence_of :data_hash
end
