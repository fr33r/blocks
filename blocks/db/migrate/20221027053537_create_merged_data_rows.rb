class CreateMergedDataRows < ActiveRecord::Migration[7.0]
  def change
    create_table :merged_data_rows do |t|

      t.timestamps
    end
  end
end
