require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "path"))
require 'webmock/cucumber'
require 'selenium-webdriver'
WebMock.disable_net_connect!(:allow_localhost => true)

Given(/^I am on the home page$/) do
  visit 'http://0.0.0.0:3000'
  # visit root_path
end

When(/^I search for "(.*?)"$/) do |phrase|
  fill_in 'q', :with => phrase
  click_button('search')
end

Then(/^I should see "(.*?)" publications in the results$/) do |publisher|
  within(:css, "#documents") do
    page.assert_selector(:xpath, "div/dl/dd[text()='#{publisher}']", :minimum => 1)
  end
end

And(/^I should see a (.*?) facet under format$/) do |facet|
  within(:css, "#facets") do
    click_link("Format")
    expect(page.find(:css, ".facet_limit > ul")).to be_visible
    expect(page.find(:xpath, "//a[text()='#{facet}']")).to have_content
  end
end
