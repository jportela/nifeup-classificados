class CreateAdUser < ActiveRecord::Migration
  def self.up
    create_table :ads_users, :id => false do |t|
      t.references :ad
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :browsers_oses
  end
end
