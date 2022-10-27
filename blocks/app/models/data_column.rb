# Represents a single column within a data file format.
class DataColumn < ApplicationRecord
  # validations.
  validate_presence_of :name
end
