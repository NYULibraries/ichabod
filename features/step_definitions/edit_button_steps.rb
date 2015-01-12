Then(/^I should get to the "(.*?)" form$/) do |form|
   expect(page.find(:xpath, "//form[@id='#{form}_nyucore_sdr:DSS-NYCDCP_Mappluto_Test_11v1-DSS-jam_mappluto_7OR']"))
end

Then(/^the search results should have link "(.*?)"$/) do |link|
  expect(documents_list_container).to have_link(link)
end

And(/^I click on the first "(.*?)" link$/) do |link_text|
    accept_javascript_confirms
    first(:link, link_text).click
end

And(/^I click on the last "(.*?)" link$/) do |link_text|
    accept_javascript_confirms
    all(:link,link_text).last.click
end

When(/^I click on the "(.*?)" link$/) do |link_text|
    accept_javascript_confirms
    click_on(link_text)
end

Given(/^"(.*?)" records with title "(.*?)" exists$/) do |number_of_records, title|
  FactoryGirl.create_list(:nyucore,number_of_records.to_i,title: title)
end

Given(/^I navigate to the page "(.*?)" of the search results$/) do |page_number|
  click_on(page_number)
end

Then(/^the number of records should decrease to "(.*?)"$/) do |number_of_records|
  expect(page.find('.page_entries').text).to have_content "of #{number_of_records}"
end

Then(/^I should return to the page "(.*?)" of the search results$/) do |page_number|
  expect(find('.col-md-9').find('.active').text).to eq page_number
end

Then(/^I should get to the edit form for "(.*?)"$/) do |title|
  expect(page.find('#nyucore_title').value).to eq "#{title}"
end

Given(/^I navigate to details display of the last result$/) do
  within(documents_list_container) do
    find(".document:last-child h5.index_title a").click
  end
end
