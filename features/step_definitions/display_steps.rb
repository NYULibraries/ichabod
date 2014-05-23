

Then(/^I should get a dataset with the link "(.*?)"$/) do |download|
   node = page.find(:xpath, '//div[@id="content"]')
   node.should have_link(download)
end

Then(/^I should get "(.*?)" field in all results$/) do |field|
  node = page.find(:xpath, '//div[@id="content"]')
  expect(node.all('dt', :text => field).count).to be == 10
end

And(/^I navigate to details display of the first result$/) do
  within(page.find(:xpath, '//div[@id="content"]')) do
    find(:xpath, "//a[@data-counter='1']").click
  end
end

Then(/^I should get "(.*?)" field in the details display$/) do |field|
  node = page.find(:xpath, '//div[@id="content"]')
  expect(node.all('dt', :text => field).count).to be == 1
end