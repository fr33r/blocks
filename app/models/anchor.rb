# frozen_string_literal: true

class Anchor < ApplicationRecord
  # associations.
  belongs_to :file_format
  has_and_belongs_to_many :columns

  # validations.
  validates_presence_of :name
end
