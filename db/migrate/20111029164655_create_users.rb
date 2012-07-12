class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.boolean :admin
      t.float :rate
      t.datetime :blocked_until

      t.timestamps
    end
  end
end
