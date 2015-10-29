Given(/^I (change|revert) the "(.*?)" source data in the "(.*?)" field to "(.*?)" for the record identified by "(.*?)"$/) do |method, source, field, data, identifier|
  prefix = prefix_for_source(source)
  if method == "change"
    FileUtils.cp(fixture_file(prefix, ".xml.new"), fixture_file("#{prefix}_tmp"))
  elsif method == "revert"
    FileUtils.cp(fixture_file(prefix, ".xml.orig"), fixture_file("#{prefix}_tmp"))
  end
end

And(/^I reload the "(.*?)" source data into Ichabod$/) do |source|
  name = name_for_source(source)
  prefix = prefix_for_source(source)
  if source == "Spatial Data Repository"
  	Ichabod::DataLoader.new(name).load 
  else
  	Ichabod::DataLoader.new(name, fixture_file("#{prefix}_tmp")).load
  end
end
