class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.text :reason
      t.references :user
      t.references :comment

      t.timestamps
    end
    add_index :reports, :user_id
    add_index :reports, :comment_id
  end
end
