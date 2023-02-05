# frozen_string_literal: true

class RowLink < ApplicationRecord
  # associations.
  belongs_to :source_row, class_name: Row.to_s, foreign_key: :source_row_id
  belongs_to :target_row, class_name: Row.to_s, foreign_key: :target_row_id
end
