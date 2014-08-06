Given (/^I "(change|revert)?" the "(.*?)" source data in the "(.*?)" field to "(.*?)" for the record identified by "(.*?)"$/) do |method, source, field, data, identifier|
  if method == "change"
    FileUtils.cp(fixture_file(source, ".xml.new"), fixture_file("#{source}_tmp"))
  elsif method == "revert"
    FileUtils.cp(fixture_file(source, ".xml.orig"), fixture_file("#{source}_tmp"))
  end
end

And (/^I reload the "(.*?)" source data into Ichabod$/) do |source|
  Ichabod::DataLoader.new(fixture_file("#{source}_tmp"), source).load
end
