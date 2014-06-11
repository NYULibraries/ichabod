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
