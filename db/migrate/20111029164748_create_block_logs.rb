class CreateBlockLogs < ActiveRecord::Migration
  def change
    create_table :block_logs do |t|
      t.datetime :begin
      t.datetime :end
      t.text :reason
      t.references :user

      t.timestamps
    end
  end
end
