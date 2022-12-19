class AddRowsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :rows, id: :uuid  do |t|
      t.string :state, null: false
      t.integer :row_number, null: false
      t.string :data_hash, null: false
      t.jsonb :data, null: false
      t.uuid :created_by
      t.uuid :updated_by
      t.belongs_to :data_file, type: :uuid
      t.timestamps
    end

    add_index :rows, :data_hash
  end
end
