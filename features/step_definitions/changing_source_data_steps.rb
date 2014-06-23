Given (/^I update "(.*?)" data to "(.*?)" outside of Ichabod$/) do |source, file| 
  Ichabod::DataLoader.new(file, source).load
end

Given (/^I change the "(.*?)" source data in the "(.*?)" field to "(.*?)" for the record identified by "(.*?)"$/) do |source, field, data, identifier|
  if data == "New York City Dept of City Planning" then 
    @file = "spec/fixtures/new_battalions.xml" 
  elsif data == "New York City Department of City Planning" then  
    @file = "spec/fixtures/orig_battalions.xml" 
  end
end

And (/^I reload the "(.*?)" source data into Ichabod$/) do |source|
    Ichabod::DataLoader.new(@file, source).load
end


