require 'spec_helper'

describe "ListIdentifiers", :type => :oai do
  before do
    get "oai?verb=ListIdentifiers"
  end
  it "responds to a list identifiers request" do
    last_response.status.should eql(200)
  end
  it "has 22 records in it's list identifiers" do
    #doc.should eq("Monkeys!!")
    #count = doc.root.OAI-PMH.ListIdentifiers.children.count
    doc = Nokogiri::XML(last_response.body)
    doc.at("ListIdentifiers").children.count.should eq(22)
  end
  it "has /libguides:guides-nyu-edu-content-php-pid-38898 as its first records" do
    doc = Nokogiri::XML(last_response.body)
    doc.at("header/identifier").text.should eql('/libguides:guides-nyu-edu-content-php-pid-38898')
  end
end
