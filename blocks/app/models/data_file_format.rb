# Represents a data file format.
class DataFileFormat < ApplicationRecord
  # associations.
  has_many :data_files
  has_many :data_columns
  has_one :data_anchor
end
