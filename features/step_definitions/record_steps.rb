Given(/^I am on the "New Item" form$/) do
  visit new_nyucore_path
end

When(/^I enter the fields:$/) do |table|
  criteria = table.rows_hash.each do |field, value|
    fill_in field, :with => value
  end
end

When(/^I save the record$/) do
  click_on("Save")
end

Then(/^I should see the message "(.+?)"$/) do |message|
  expect(page.find(:css, "div.alert.alert-info")).to have_content message
end
