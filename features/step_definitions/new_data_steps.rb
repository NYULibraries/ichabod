Given (/^I update "(.*?)" data to "(.*?)" outside of Ichabod$/) do |source, file| 
  Ichabod::DataLoader.new(file, source).load
end