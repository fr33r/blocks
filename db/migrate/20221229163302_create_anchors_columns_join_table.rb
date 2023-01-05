class CreateAnchorsColumnsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :anchors, :columns, column_options: { type: :uuid }
  end
end
