class CreateDataFileFormats < ActiveRecord::Migration[7.0]
  def change
    create_table :data_file_formats do |t|

      t.timestamps
    end
  end
end
