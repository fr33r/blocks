# Represents a collection of columns that will be used to link (anchor)
# rows from various files together.
class DataAnchor < ApplicationRecord
  # associations.
  has_many :data_columns
  belongs_to :data_file_format

  # retrieves the column names included within the data anchor as symbols.
  def column_names_sym
    data_columns.map(&:name).map(&:downcase).map(&:to_sym)
  end

  # retrieves the column names included within the data anchor.
  def column_names
    data_columns.map(&:name).map(&:upcase)
  end
end
