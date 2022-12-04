class AddRowsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :rows, id: :uuid  do |t|
      t.string :state
      t.string :data_hash
      t.jsonb :data
      t.uuid :created_by
      t.uuid :updated_by
      t.timestamps
    end

    add_index :rows, :data_hash
  end
end
