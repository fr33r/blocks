class CreatePipelines < ActiveRecord::Migration[7.0]
  def change
    create_table :pipelines, id: :uuid do |t|
      # belongs to report format.
      t.timestamps
    end
  end
end
