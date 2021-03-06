Then(/^I should get "(.*?)" field in all results$/) do |field|
  expect(documents_list_container.all('dt', :text => field)).to have_exactly(10).items
end


And(/^I navigate to details display of the first result$/) do
  within(documents_list_container) do
    find(".document:first-child h5.index_title a").click
  end
end

Then(/^I should get "(.*?)" field in the details display$/) do |field|
  expect(document_container.all('dt', :text => field)).to have_exactly(1).item
end


Then(/^I should see the value "(.*?)" in the "(.*?)" field$/) do |value, field|
    expect(document_field_value(field)).to have_content(value)
end
