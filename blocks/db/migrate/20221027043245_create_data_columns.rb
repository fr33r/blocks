class CreateDataColumns < ActiveRecord::Migration[7.0]
  def change
    create_table :data_columns do |t|
      t.string :name
      t.string :datatype

      t.timestamps
    end
  end
end
