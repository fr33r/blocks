class CreateDataRowGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :data_row_groups do |t|

      t.timestamps
    end
  end
end
