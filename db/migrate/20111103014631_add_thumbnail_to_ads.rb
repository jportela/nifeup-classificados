class AddThumbnailToAds < ActiveRecord::Migration
  def self.up
    add_column :ads, :thumbnail_file_name,    :string
    add_column :ads, :thumbnail_content_type, :string
    add_column :ads, :thumbnail_file_size,    :integer
    add_column :ads, :thumbnail_updated_at,   :datetime
    remove_column :ads, :thumbnail
  end

  def self.down
    remove_column :ads, :thumbnail_file_name
    remove_column :ads, :thumbnail_content_type
    remove_column :ads, :thumbnail_file_size
    remove_column :ads, :thumbnail_updated_at
    add_column :ads, :thumbnail, :string
  end
end
