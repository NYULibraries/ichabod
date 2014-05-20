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

And(/^I limit the search by a facet "(\w+.*?\s\w+.*?)"$/) do |facet|
  within(:css, '#facets') do
    click_link("Format")
    click_link("#{facet}")
  end
end

  Given(/^I Limit search to "(.*?)" in "(.*?)"$/) do |value,facet|
    visit root_path
    within(:css, '#facets') do
      click_link("#{facet}")
      click_link("#{value}")
    end
  end

Given(/^I search for "(.*?)"$/) do |value|
   step %{I search on the phrase "#{value}"}
end

Then(/^I get dataset with title "(.*?)"$/) do |title|
   node=page.find(:xpath, '//div[@id="documents"]')
   node.should have_link(title)
end

