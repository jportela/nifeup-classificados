class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :mime_type
      t.string :link
      t.references :ad

      t.timestamps
    end
    add_index :resources, :ad_id
  end
end
