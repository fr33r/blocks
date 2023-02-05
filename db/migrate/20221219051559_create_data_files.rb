class CreateDataFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :data_files, id: :uuid do |t|
      t.string :state, null: false
      t.string :filename, null: false
      t.integer :total_row_count, null: false
      t.datetime :processing_started_at
      t.datetime :processing_ended_at
      t.belongs_to :file_format, type: :uuid, null: false
      t.timestamps
    end

    add_index :data_files, :filename
  end
end
