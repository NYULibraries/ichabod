
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