Given(/^I am on the default search page$/) do
  visit root_path
end

When(/^I perform an empty search$/) do
  within(:css, "form.search-query-form") do
    fill_in 'Search...', :with => ''
  end
  click_button("Search")
end

Then(/^I should see search results$/) do
  expect(page.all("#documents .document").count).to be > 0
end

When(/^I search on the phrase "(.*?)"$/) do |phrase|
  within(:css, "form.search-query-form") do
    fill_in 'Search...', :with => phrase
  end
  click_button("Search")
end
