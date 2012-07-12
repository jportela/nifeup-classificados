class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.integer :closed
      t.string :thumbnail
      t.text :description
      t.integer :final_eval
      t.references :user
      t.references :section

      t.timestamps
    end
    add_index :ads, :user_id
    add_index :ads, :section_id
  end
end
