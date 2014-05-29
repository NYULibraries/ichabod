Given(/^I am on the default search page$/) do
  visit root_path
end

When(/^I perform an empty search$/) do
  within(:css, "form.search-query-form") do
    fill_in 'Search...', :with => ''
  end
  click_button("Search")
end

Then(/^I should (not )?see search results$/) do |negator|
  if negator
    expect(page.all("#documents .document").count).to be 0
  else
    expect(page.all("#documents .document").count).to be > 0
  end
end

When(/^I search on the phrase "(.*?)"$/) do |phrase|
  step "I am on the default search page" unless current_path == root_path
  within(:css, "form.search-query-form") do
    fill_in 'Search...', :with => phrase
  end
  click_button("Search")
end

And(/^I limit the search by the "(.+?)" facet to "(.+?)"$/) do |facet_name, facet_value|
  within(:css, '#facets') do
    click_on(facet_name)
    click_on(facet_value)
  end
end

Given(/^I limit search to "(.*?)" in "(.*?)" category$/) do |facet,category|
  visit root_path
  within(:css, '#facets') do
    click_link("#{category}")
    click_link("#{facet}")
  end
end

And(/^I should see a (.*?) facet under Format$/) do |facet|
  within(:css, "#facets") do
    click_link("Format")
    expect(page.find(:css, ".facet_limit > ul")).to be_visible
    expect(page.find(:xpath, "//a[text()='#{facet}']")).to have_content
  end
end

Given(/^I search for "(.*?)"$/) do |value|
   step %{I search on the phrase "#{value}"}
end

Then(/^I get dataset with title "(.*?)"$/) do |title|
   node=page.find(:xpath, '//div[@id="documents"]')
   node.should have_link(title)
end