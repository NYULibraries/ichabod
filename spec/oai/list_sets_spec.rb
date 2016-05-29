require 'spec_helper'

describe "ListSets", :type => :oai do
  it "responds to a list sets request" do
  	get "oai?verb=ListSets"
    last_response.status.should eql(200)
    doc = Nokogiri::XML(last_response.body)
    doc.at("error")["code"].should eq("noSetHierarchy")
    doc.at("error").text.should eq("This repository does not support sets.")
  end
end