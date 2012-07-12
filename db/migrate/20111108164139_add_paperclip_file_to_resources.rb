class AddPaperclipFileToResources < ActiveRecord::Migration
  def self.up
    add_column :resources, :link_file_name,    :string
    add_column :resources, :link_content_type, :string
    add_column :resources, :link_file_size,    :integer
    add_column :resources, :link_updated_at,   :datetime
    add_column :resources, :description, :string
    remove_column :resources, :mime_type
    remove_column :resources, :link
  end

  def self.down
    remove_column :resources, :link_file_name
    remove_column :resources, :link_content_type
    remove_column :resources, :link_file_size
    remove_column :resources, :link_updated_at
    remove_column :resources, :description
    add_column :resources, :mime_type, :string
    add_column :resources, :link, :string
  end
end
