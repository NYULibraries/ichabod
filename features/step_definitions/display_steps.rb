

Then(/^I should get a dataset with the link "(.*?)"$/) do |download|
  documents_container.should have_link(download)
end

Then(/^I should get "(.*?)" field in all results$/) do |field|
  expect(documents_container.all('dt', :text => field).count).to be == 10
end

And(/^I navigate to details display of the first result$/) do
  within(documents_container) do
    find(:xpath, "//a[@data-counter='1']").click
  end
end

Then(/^I should get "(.*?)" field in the details display$/) do |field|
  expect(document_container.all('dt', :text => field).count).to be == 1
end