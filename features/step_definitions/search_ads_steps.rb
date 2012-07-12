When /^I submit a search$/ do
  visit '/ads/dashboard?search_terms=&section_id=1&commit=Go'
end

When /^I type "([^"]*)" in the search area$/ do |text|
  old_text = find('#search_text_field').value || ""
  fill_in 'search_text_field', :with => old_text + text
end

When /^I submit the search$/ do
  find('#search_button').click
end

When /^I wait a second$/ do
  sleep 1
end

Then /^(?:the ads|they) should all have a keyword that begins with or matches "([^"]*)"$/ do |keyword|
  # assert false, all_visible_ads.collect { |elem| Ad.find(Dashboard.ad_id(elem)).title + " " + Ad.find(Dashboard.ad_id(elem)).ad_tags.collect { |at| at.tag }.to_s }.to_s
  all_visible_ads.each do |elem|
    ad = Ad.find(Dashboard.ad_id(elem))
    words = ad.title.split + ad.ad_tags.collect {|ad_tag| ad_tag.tag }
    assert words.any? { |word| word.start_with? keyword }, "No keyword starting with \"#{keyword}\" in ad #{ad.id}. Keywords: #{words}"
  end
end
