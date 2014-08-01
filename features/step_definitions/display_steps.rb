Then(/^I should get a dataset with the link "(.*?)"$/) do |download|
  expect(documents_list_container).to have_link(download)
end

Then(/^I should get "(.*?)" field in all results$/) do |field|
  expect(documents_list_container.all('dt', :text => field)).to have_exactly(10).items
end

And(/^I navigate to details display of the first result$/) do
  within(documents_list_container) do
    find(:xpath, "//a[@data-counter='1']").click
  end
end

Then(/^I should get "(.*?)" field in the details display$/) do |field|
  expect(document_container.all('dt', :text => field)).to have_exactly(1).item
end

Then(/^I should see the link "(.*?)" in the "(.*?)" field$/) do |link, field|
  expect(document_field_value(field)).to have_link(link)
end
