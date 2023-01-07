class CreateAnchorValues < ActiveRecord::Migration[7.0]
  def change
    create_table :anchor_values, id: :uuid do |t|
      t.belongs_to :row, type: :uuid
      t.belongs_to :anchor, type: :uuid
      t.jsonb :data, null: false
      t.string :data_hash, null: false
      t.timestamps
    end
  end
end
