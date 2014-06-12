Then(/^the record should have link "(.*?)"$/) do  |link_text|
  expect(page.all(:xpath, "//a[text()='#{link_text}']").count).to be > 0
 end

Given(/^I view record with id "(.*?)"$/) do |id|
  visit "#{nyucores_path}/#{id}"
end

Then(/^the record should not have link "(.*?)"$/) do |link_text|
 expect(page.all(:xpath, "//a[text()='#{link_text}']").count).to be 0
end

Given(/^I am not logged in$/) do
  ENV['PDS_HANDLE'] = nil
end

Around('@loggedin_GIS') do |scenario, block|
  VCR.use_cassette('logged in GIS Cataloger', record: :none) do
    block.call
  end
  ENV['PDS_HANDLE'] = nil
end

Around('@loggedin_FDA') do |scenario, block|
  VCR.use_cassette('logged in FDA Cataloger', record: :none) do
    block.call
  end
  ENV['PDS_HANDLE'] = nil
end
