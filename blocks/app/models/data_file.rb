# Represents a single file that has been uploaded.
class DataFile < ApplicationRecord
  # associations.
  has_many :data_rows
  belongs_to :data_file_format
end
