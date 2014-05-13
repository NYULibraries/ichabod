require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "path"))
require 'webmock/cucumber'
require 'selenium-webdriver'
WebMock.disable_net_connect!(:allow_localhost => true)

#steps defined for search dataset by publisher feature


Given(/^I am on the home page$/) do
  # visit 'http://0.0.0.0:3000'
  visit root_path
end

When(/^I search for "(.*?)"$/) do |phrase|
  fill_in 'q', :with => phrase
  click_button('search')
end

Then(/^I should see "(.*?)" publications in the results$/) do |publisher|
  within(:css, "div.document:nth-child(1)") do
    node=page.find(:css, "dd:nth-child(4)")
    node.should have_content(publisher)
  end
end

And(/^I should see a (.*?) facet under format$/) do |facet|
  within(:css, "#facets") do
    click_link("Format")
    expect(page.find(:css, ".facet_limit > ul")).to be_visible
    # node=page.find(:css, "h5 a")
    # node.should have_content("Format")
    expect(page.find(:xpath, "//a[text()='#{facet}']")).to have_content
    # node=page.find(:css, "a.facet_select:nth-child(2)")
    # node.should have_content(facet)
  end
end
