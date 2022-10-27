# Represents a single row from a file uploaded.
class DataRow < ApplicationRecord
  # associations.
  belongs_to :data_file
  has_one :data_file_format, through: :data_file
  belongs_to :data_row_group

  # attempts to link the row to others based on the anchors
  # for the associated data file format.
  def link!
    return unless data_row_group.nil?

    matches = find_matching_rows
    existing_data_row_group = matches.map(&:data_row_group).compact.first
    if existing_data_row_group.present?
      data_row_group = existing_data_row_group
      save!
      data_row_group
    else
      DataRowGroup.create_or_find_by!(data_rows: matches)
    end
  end

  # finds rows that have anchor column values that match this rows
  # anchor column values, while also not belonging to the same
  # file or share the same file format.
  def find_matching_rows
    class
      .joins(data_file: %i[:data_file_format])
      .where.not(data_files: { id: data_file.id, data_file_formats: { id: data_file_format.id } })
      .where("data @> '?'", anchor_values.to_json)
  end

  # retrieves the data anchor of the data file format this row
  # is associated with.
  def anchor
    data_file_format.data_anchor
  end

  # retrieves the column names included within the data anchor
  # associated to the data file format for this row.
  def anchor_column_names
    anchor.column_names
  end

  # retrieves the values of the anchor columns for this row.
  def anchor_values
    data.slice(**anchor_column_names)
  end
end
