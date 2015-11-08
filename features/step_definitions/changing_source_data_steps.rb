Given(/^I (change|revert) the "(.*?)" source data in the "(.*?)" field to "(.*?)" for the record identified by "(.*?)"$/) do |method, source, field, data, identifier|
  prefix = prefix_for_source(source)
  # in case, we are doing this test for more than 
  # one type of dataset
  # making a hash of dataset prefixes and their extensions
  ext = get_ext(prefix)

  if method == "change"
    FileUtils.cp(fixture_file(prefix, "#{ext}.new"), fixture_file("#{prefix}_tmp",ext))
  elsif method == "revert"
    FileUtils.cp(fixture_file(prefix, "#{ext}.orig"), fixture_file("#{prefix}_tmp",ext))
  end
end

And(/^I reload the "(.*?)" source data into Ichabod$/) do |source|
  name = name_for_source(source)
  prefix = prefix_for_source(source)
  ext = get_ext(prefix)
  Ichabod::DataLoader.new(name, fixture_file("#{prefix}_tmp",ext)).load

end
