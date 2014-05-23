

Then(/^I should get a dataset with the link "(.*?)"$/) do |download|
   node = page.find(:xpath, '//div[@id="content"]')
   #node3 = node2.find(:xpath, '//div[@id="documents"]')
   node.should have_link(download)
end

Then(/^I should get "(.*?)" field in all results$/) do |field|
  node = page.find(:xpath, '//div[@id="content"]')
  expect(node.all('dt', :text => field).count).to be == 10

   #node.all('dt', :text => field).count == 10
   #<dt class="blacklight-desc_metadata__available_tesim">Online Resource:</dt>
end

And(/^I navigate to details display of the first result$/) do
  #within(:xpath, '//div[@id="content"]') do
  within(page.find(:xpath, '//div[@id="content"]')) do
    find(:xpath, "//a[@data-counter='1']").click
  end
  #locate("//a[@data-counter='1']").click
end

Then(/^I should get "(.*?)" field in the details display$/) do |field|
  node = page.find(:xpath, '//div[@id="content"]')
  expect(node.all('dt', :text => field).count).to be == 1

   #node.all('dt', :text => field).count == 10
   #<dt class="blacklight-desc_metadata__available_tesim">Online Resource:</dt>
end