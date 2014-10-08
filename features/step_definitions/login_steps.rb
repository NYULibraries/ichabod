Around('@loggedin') do |scenario, block|
  VCR.use_cassette('logged in users', match_requests_on: [:method, :uri, :body], record: :none) do
    block.call
  end
  ENV['PDS_HANDLE'] = nil
end

Given(/^I am logged in as an admin$/) do
  ENV['PDS_HANDLE'] = "Test_Admin"
end

Given(/^I am logged in as "(.*?)"$/) do |user|
  ENV['PDS_HANDLE'] = format_pds_handle(user)
end

Then(/^I should see "Log-out"$/) do
  within(:css, "ol.nyu-breadcrumbs > li.nyu-login") do
    expect(page).to have_content("Log-out")
  end
end
