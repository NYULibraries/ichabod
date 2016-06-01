require 'spec_helper'

describe "ListMetadataFormats", :type => :oai do
  it "responds to a list of metadata formats request" do
    get "oai?verb=ListMetadataFormats"
    last_response.status.should eql(200)
    doc = Nokogiri::XML(last_response.body)
    doc.at("metadataPrefix").text.should eq("oai_dc")
    doc.at("schema").text.should eq("http://www.openarchives.org/OAI/2.0/oai_dc.xsd")
    doc.at("metadataNamespace").text.should eq("http://www.openarchives.org/OAI/2.0/oai_dc/")
  end
end
