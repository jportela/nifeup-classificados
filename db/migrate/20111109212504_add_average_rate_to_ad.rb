class AddAverageRateToAd < ActiveRecord::Migration
  def change
    add_column :ads, :average_rate, :float
  end
end
