# Represents a single permutation of rows linked via a data row group.
class MergedDataRow < ApplicationRecord
  belongs_to :data_row_group
end
