class CreateFinalEvaluations < ActiveRecord::Migration
  def change
    create_table :final_evaluations do |t|
      t.integer :value
      t.text :comment
      t.references :user

      t.timestamps
    end
  end
end
