class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user
      t.references :ad

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :ad_id
  end
end
