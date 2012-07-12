class Resource < ActiveRecord::Base
  belongs_to :ad
  has_attached_file :link, :styles => { :gallery => "60x60", :medium => "200x200" }
  
  validates_attachment_presence :link
  validates_attachment_size :link, :less_than => 5.megabytes
  validates_attachment_content_type :link, :content_type => ['image/jpeg', 'image/png', 'application/pdf']
  
  def thumbnail 
    if (self.link_content_type == "image/jpeg" or self.link_content_type == "image/png")
      self.link.url(:medium)
    elsif (self.link_content_type == "application/pdf")
      "pdf_icon_large.png"
    end
  end
end
