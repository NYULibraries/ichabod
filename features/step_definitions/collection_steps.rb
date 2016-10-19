Given(/^I am on the "New Collection" form$/) do
   visit new_collection_path
end

Given(/^the collection "(.*?)" exists$/) do |title|
   @collection = FactoryGirl.create(:collection, title: title)
end

Given(/^I am on the Edit Collection form$/) do
   visit edit_collection_path(@collection)
end

When(/^I am on the collections list$/) do
    visit collections_path
end

Then(/^I should see the detailed collection view$/) do
  expect(page.first(:css, "div.alert.alert-info")).to have_content message
end

Then(/^I should (not )?see the title "(.*?)" in the collections list$/) do |negator, title|
  visit collections_path
  if negator
    expect(page.first(:css, ".nyu-container")).not_to have_content title
  else
    expect(page.first(:css, ".nyu-container")).to have_content title
  end
end

Given(/^the field "(.*?)" is defined as "(.*?)"$/) do |field, value|
  @collection[:"#{field}"] = value
end

When(/^I click on the "(.*?)" link for "(.*?)"$/) do |button_text,value|
  within(:xpath, "//tr[td/text()='#{value}']") do
   click_link("#{button_text}")
  end
end

Then(/^field "(.*?)" should be marked as required$/) do |field|
  expect(page).to have_css("#collection_#{field}.required")
end

Then(/^field "(.*?)" should be checked$/) do |field|
  expect(page.has_checked_field?("collection_#{field}")).to eq true
end

Then(/^I should see the "(.*?)" title/) do |value|
  expect(page).to have_text(value)
end