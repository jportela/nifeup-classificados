class CreateAdTags < ActiveRecord::Migration
  def change
    create_table :ad_tags do |t|
      t.string :tag
      t.references :ad

      t.timestamps
    end
    add_index :ad_tags, :ad_id
  end
end
