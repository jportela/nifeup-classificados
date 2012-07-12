Given /^the system has some ads in section "([^"]+)"$/i do |section|
  3.times do |i|
    ad = Ad.new :title => i.to_s
    ad.section_id = Section.find_by_name(section).id
    assert ad.save
  end
end

Given /^the system has some ads with the keyword "([^"]*)" in section "([^"]+)"$/ do |keyword, section|
  3.times do |i|
    ad = Ad.new :title => keyword + " " + i.to_s
    ad.section_id = Section.find_by_name(section).id
    assert ad.save
  end
  
  3.times do |i|
    ad = Ad.new :title => i.to_s
    ad.section_id = Section.find_by_name(section).id
    assert ad.save

    tag = AdTag.new :ad_id => ad.id, :tag => keyword
    assert tag.save
  end
end

Given /^the system has already an ad with id "([0-9]+)"$/ do |id|
  assert Ad.find(id.to_i).destroy if Ad.exists?(id.to_i)
  step 'the system has already a user with id "1"'
  
  @ad = Ad.new(:title => id, :user_id => 1)
  @ad.id = id.to_i
  @ad.section_id = Section.first.id
  assert @ad.save
end

Given /^(?:the ad|it) has information in all its fields$/ do
  @ad.average_rate = 4
  @ad.relevance_factor = 0.2
  @ad.description = 'This is an ad'
  assert @ad.save
  
  assert AdTag.new(:ad_id => @ad.id, :tag => "keyword0").save
  assert AdTag.new(:ad_id => @ad.id, :tag => "keyword1").save
end

Given /^the system has already a user with id "([0-9]+)"$/ do |id|
  return if User.exists?(id.to_i)
  
  user = User.new(:username => 'ei07070', :admin => false)
  user.id = id.to_i
  assert user.save
end

Then /^the request should succeed$/ do
  assert_equal 200, page.driver.status_code
end
