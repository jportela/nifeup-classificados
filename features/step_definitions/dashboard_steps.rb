When /^I open the dashboard$/i do
  visit '/'
end

When /^I select the section "([^"]+)"$/i do |section|
  section_id = Section.find_by_name(section).id
  find(Dashboard.section_tab_id(section_id)).click
  assert_equal section_id, find('#section_id').value.to_i
end

Then /^I should see a list of ads$/i do
  assert page.has_selector?(Dashboard.main_id), 'The main ad container wasn\'t found.'
  within(Dashboard.main_id) do
    assert has_selector?(Dashboard.ad_class), "There were no ads in the main container. Ads in database: #{Ad.all}"
  end
end

Then /^(?:the ads|they) should all be from the selected section$/i do
  section = Section.find(selected_section_id)
  step "they should all be from the section \"#{section.name}\""
end

Then /^(?:the ads|they) should all be from the section "([^"]+)"$/i do |section|
  all_visible_ads.each do |elem|
    ad = Ad.find(Dashboard.ad_id(elem))
    assert_equal section, ad.section.name, "The ad #{ad.id} isn't from section \"#{section}\""
  end
end

Then /^(?:the ads|they) should be ordered by relevance$/i do
  last_ad = nil
  all_visible_ads.each do |elem|
    ad = Ad.find(Dashboard.ad_id(elem))
    if last_ad then
      assert ad.relevance <= last_ad.relevance
    end
    last_ad = ad
  end
end
