Given(/^I am on the "New Item" form$/) do
  visit new_nyucore_path
end

When(/^I enter the fields:$/) do |table|
  table.rows_hash.each do |field, value|
    fill_in field, :with => value
  end
end

When(/^I save the record$/) do
  click_on("Save")
end

Then(/^I should see the message "(.+?)"$/) do |message|
  expect(page.first(:css, "div.alert.alert-info")).to have_content message
end

Given(/^the record "(.*?)" exists$/) do |title|
  @record = FactoryGirl.create(:nyucore, title: title)
end

Given(/^I am on the "Edit Item" form for "(.*?)"$/) do |title|
  visit edit_nyucore_path(@record)
end

When(/^I delete the record$/) do
  accept_javascript_confirms
  click_on('Destroy')  
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
  table.rows_hash.each do |field, value|
    expect(page.find("##{field}").value).to have_content value
  end
end

Then(/^I should see the immutable fields:$/) do |table|
  table.rows_hash.each do |field, value|
    page.find(:xpath, "//label[@for='nyucore_#{field.downcase}']/following-sibling::div[@class='source']").text.should == value
  end
end
