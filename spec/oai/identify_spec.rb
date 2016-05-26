require 'spec_helper'

describe "Identify", :type => :oai do
  it "responds to an identify request" do
    get "oai?verb=Identify"
    last_response.status.should eql(200)
    doc = Nokogiri::XML(last_response.body)
    doc.at("baseURL").text.should eq("http://ichabod.library.nyu.edu")
    doc.at("deletedRecord").text.should eq("transient")
  end
end