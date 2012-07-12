class ChangeClosedDefaultAtAd < ActiveRecord::Migration
  def up
    change_column_default :ads, :closed, 0
  end

  def down
    change_column_default :ads, :closed, nil
  end
end
