Given(/^I have datasets with terms like (\w+.*?$)$/) do |kw|
   @dataset1 = {:description => "foo #{kw}", :format => 'Geospatial Data'} 
   @dataset2 = {:description => kw, :format => 'Geospatial Data'} 
   @datasets = [@dataset1,@dataset2]
end

When(/^I enter the keyword (\w+)$/) do |kw|
   @keyword = kw
end

And(/^I enter the phrase (\w+.*?$)$/) do |p|
   @phrase = p
end
Then(/^I find results$/) do
  @term = "#{@phrase} #{@keyword}"
  @term.should =~  /#{@dataset2[:description]}/
end

And(/^limit the results by a facet (\w+\s\w+)$/) do |kw|
   @dataset2[:format] == kw
end



