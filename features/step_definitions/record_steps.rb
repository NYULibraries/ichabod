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

Given(/^the record "(.*?)" exists$/) do |title|
  @record = FactoryGirl.create(format_factory(title))
end

Given(/^I am on the "Edit Item" form for "(.*?)"$/) do |title|
  visit edit_nyucore_path(@record)
end

When(/^I delete the record$/) do
  visit nyucores_path
  accept_confirms
  page.find(:xpath, "//a[@href='#{nyucore_path(@record)}'][@data-method='delete']").click
end

When(/^I click on "(.+?)"$/) do |link_text|
  click_on(link_text)
end

Given(/^I click on all the "(.*?)" buttons$/) do |button_text|
  page.all(:xpath, "//a[text()='#{button_text}']").each do |button|
    button.click
  end
end

Then(/^I should see the fields:$/) do |table|
  pending
end
