class CreateFileFormats < ActiveRecord::Migration[7.0]
  def change
    create_table :file_formats, id: :uuid do |t|
      t.string :state, null: false
      t.string :name, null: false
      t.uuid :created_by
      t.uuid :updated_by
      t.timestamps
    end

    add_index :file_formats, :name
  end
end
