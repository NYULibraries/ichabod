require 'spec_helper'

describe "GetRecord", :type => :oai do
  it "404s to a non-existant identier" do
    get "oai?verb=GetRecord&metadataPrefix=oai_dc&identifier=chickens"
    last_response.status.should eql(404)
  end
  it "responds correctly to a GetRecord request with a valid identifier and oai_dc" do
    get "oai?verb=GetRecord&metadataPrefix=oai_dc&identifier=nyupress:9780814712771"
    last_response.status.should eql(200)
    doc = Nokogiri::XML(last_response.body)
    #doc.should eq("Monkeys")
    doc.at('OAI-PMH/GetRecord/record/header/identifier').text.should eq("/nyupress:9780814712771")
    #doc.at('OAI-PMH/GetRecord/record/metadata/oai_dc:dc/dc:title').text.should eq("The Prostitution of Sexuality")
    namespaces = { 'oai' => 'http://www.openarchives.org/OAI/2.0/',
                   'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/',
                   'dc' => 'http://purl.org/dc/elements/1.1/'
                 }
    doc.at_xpath('oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/oai_dc:dc/dc:title', namespaces).text.should eq("The Prostitution of Sexuality")
    doc.at_xpath('oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/oai_dc:dc/dc:identifier', namespaces).text.should eq("9780814712771")
    doc.at_xpath('oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/oai_dc:dc/dc:creator', namespaces).text.should eq("Kathleen L. Barry")
    doc.at_xpath('oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/oai_dc:dc/dc:date', namespaces).text.should eq("1995")
    doc.at_xpath('oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/oai_dc:dc/dc:type', namespaces).text.should eq("Book")

    #doc.at("baseURL").text.should eq("http://ichabod.library.nyu.edu")
    #doc.at("deletedRecord").text.should eq("transient")
  end
end
