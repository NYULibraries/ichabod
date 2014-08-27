Given(/^I am on the default search page$/) do
  visit root_path
end

##
# Searching steps
When(/^I perform an empty search$/) do
  ensure_root_path
  search_phrase('')
end

When(/^I search on the phrase "(.*?)"$/) do |phrase|
  ensure_root_path
  search_phrase(phrase)
end

Given(/^I search for "(.*?)"$/) do |phrase|
  ensure_root_path
  search_phrase(phrase)
end

##
# Results steps
Then(/^I should (not )?see search results$/) do |negator|
  if negator
    expect(documents_list).to have_exactly(0).items
  else
    expect(documents_list).to have_at_least(1).items
  end
end

Then(/^I get a dataset with the title "(.*?)"$/) do |title|
  expect(documents_list_container).to have_link(title)
end

##
# Faceting steps
Given(/^I (limit|filter) my search to "(.*?)" under the "(.*?)" category$/) do |a, facet, category|
  ensure_root_path
  limit_by_facet(category, facet)
end

When(/^I limit my results to "(.*?)" under the "(.*?)" category$/) do |facet, category|
  ensure_root_path
  limit_by_facet(category, facet)
end

And(/^I should see a "(.*?)" facet under the "(.*?)" category$/) do |facet, category|
  within(:css, "#facets") do
    click_link(category)
    expect(page.find(:css, ".facet_limit > ul")).to be_visible
    expect(page.find(:xpath, "//a[text()='#{facet}']")).to have_content
  end
end
