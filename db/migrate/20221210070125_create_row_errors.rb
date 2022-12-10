class CreateRowErrors < ActiveRecord::Migration[7.0]
  def change
    create_table :row_errors, id: :uuid do |t|
      t.string :message, null: false
      t.belongs_to :rules
      t.belongs_to :rows
      t.timestamps
    end
  end
end
