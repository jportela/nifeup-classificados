class AddFinalEvaluationToAd < ActiveRecord::Migration
  def up
    remove_column :ads, :final_eval
    add_column :ads, :final_evaluation_id, :integer
  end
 
  def down
    add_column :ads, :final_eval, :integer
    remove_column :ads, :final_evaluation_id
  end
end
