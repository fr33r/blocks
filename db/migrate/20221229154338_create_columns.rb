class CreateColumns < ActiveRecord::Migration[7.0]
  def change
    create_table :columns, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.string :data_type, null: false
      t.boolean :required, null: false
      t.belongs_to :file_format, type: :uuid
      t.timestamps
    end

    add_index :columns, %i[file_format_id name]
  end
end
