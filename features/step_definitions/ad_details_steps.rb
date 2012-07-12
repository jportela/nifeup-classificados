When /^I open the details page for ad "([0-9]+)"$/ do |id|
  assert Ad.exists?(id.to_i), Ad.all.to_s
  visit "/ads/#{id}"
end

Then /^I should see (?:the ad's|its) title$/ do
  assert page.has_selector?(AdDetails.title_class), 'The title wasn\'t found.'
  assert_not_equal '', find(AdDetails.title_class).text, 'The title field is blank.'
end

Then /^I should see (?:the ad's|its) description$/ do
  assert page.has_selector?(AdDetails.desc_class), 'The description wasn\'t found.'
  within(AdDetails.desc_class) do
    assert_not_equal '', find('p'), 'The description is blank.'
  end
end

Then /^I should see (?:the ad's|its) comments$/ do
  assert page.has_selector?(AdDetails.comments_class), 'The comments container wasn\'t found.'
end

Then /^I should see (?:the ad's|its) author, creation date and keywords$/ do
  assert page.has_selector?(AdDetails.highlights_class)
end

