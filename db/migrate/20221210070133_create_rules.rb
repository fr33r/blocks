class CreateRules < ActiveRecord::Migration[7.0]
  def change
    create_table :rules, id: :uuid do |t|
      t.string :rule_type, null: false
      t.string :state, null: false
      t.string :name, null: false
      t.string :description
      t.jsonb :condition, null: false
      t.uuid :created_by
      t.uuid :updated_by
      t.belongs_to :pipelines
      t.timestamps
    end

    add_index :rules, :name
  end
end
