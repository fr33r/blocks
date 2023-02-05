class CreateAnchors < ActiveRecord::Migration[7.0]
  def change
    create_table :anchors, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.belongs_to :file_format, type: :uuid
      t.timestamps
    end
  end
end
