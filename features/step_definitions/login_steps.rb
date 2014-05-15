Before('@loggedin') do |scenario|
  binding.pry
  ENV["PDS_HANDLE"] = format_pds_handle("GIS Cataloger")
  UserSession.class_eval do
    def pds_handle
      # Hardcoded now but need to figure out how make it read from an env var
      ENV["PDS_HANDLE"] || super
      # "GIS_Cataloger"
    end
  end
end

Given(/^I am logged in as "(.*?)"$/) do |user|
  ENV["PDS_HANDLE"] = format_pds_handle(user)
end

Then(/^I should see "Log-out"$/) do
  within(:css, "ul.nyu-login") do
    expect(page).to have_content("Log-out")
  end
end
