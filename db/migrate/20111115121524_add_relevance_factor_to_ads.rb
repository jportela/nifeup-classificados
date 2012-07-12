class AddRelevanceFactorToAds < ActiveRecord::Migration
  def change
    add_column :ads, :relevance_factor, :float, :default => 0
  end
end
