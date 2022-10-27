class CreateDataAnchors < ActiveRecord::Migration[7.0]
  def change
    create_table :data_anchors do |t|

      t.timestamps
    end
  end
end
