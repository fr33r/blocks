class CreateRowLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :row_links do |t|
      t.uuid :source_row_id, type: :uuid, null: false
      t.foreign_key :rows, column: :source_row_id, primary_key: :id
      t.uuid :target_row_id, type: :uuid, null: false
      t.foreign_key :rows, column: :target_row_id, primary_key: :id
      t.timestamps
    end
  end
end
