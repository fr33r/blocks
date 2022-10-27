class CreateDataRows < ActiveRecord::Migration[7.0]
  def change
    create_table :data_rows do |t|
      t.string :hash
      t.json :data
      t.datetime :ingested_at
      t.integer :line_number

      t.timestamps
    end
  end
end
