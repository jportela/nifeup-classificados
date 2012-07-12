class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :value
      t.references :user
      t.references :ad

      t.timestamps
    end
    add_index :evaluations, :user_id
    add_index :evaluations, :ad_id
  end
end
