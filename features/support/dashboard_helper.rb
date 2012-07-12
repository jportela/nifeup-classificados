class Dashboard
  def self.main_id
    '#dashboard_fe_ad_container'
  end
  
  def self.ad_class
    '.fe_ad_container'
  end
  
  def self.ad_id(id)
    return "#fe_ad_container_#{id}" if id.class == Fixnum
    return /fe_ad_container_(\d+)/.match(id[:id])[1].to_i if id
    /fe_ad_container_(\d+)/
  end
  
  def self.section_tab_id(id)
    return "#section_tab_#{id}" if id
    /section_tab_(\d+)/
  end
end

def all_visible_ads
  within(Dashboard.main_id) do
    return all(Dashboard.ad_class)
  end
end

def selected_section_id
  find('#section_id').value.to_i
end
