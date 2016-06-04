require 'spec_helper'

describe "ListRecords", :type => :oai do
  it "responds correctly to a ListRecords request to harvest records from a repository" do
    get "oai?verb=ListRecords&metadataPrefix=oai_dc"
    last_response.status.should eql(200)
    doc = Nokogiri::XML(last_response.body)
    doc.at('OAI-PMH/ListRecords/record/header/identifier').text.should eq("/libguides:guides-nyu-edu-content-php-pid-38898")
    #doc.at('OAI-PMH/ListRecords/record/header/identifier').text.should eq("DSS.NYCDCP_DCPLION_10cav\DSS-Lion_GJK")
    #doc.should eq("Monkeys")
    namespaces = { 'oai' => 'http://www.openarchives.org/OAI/2.0/',
                   'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/',
                   'dc' => 'http://purl.org/dc/elements/1.1/'
                 }
    doc.at_xpath('oai:OAI-PMH/oai:ListRecords/oai:record/oai:metadata/oai_dc:dc/dc:title', namespaces).text.should eq("Data Services")
    doc.at_xpath('oai:OAI-PMH/oai:ListRecords/oai:record/oai:metadata/oai_dc:dc/dc:type', namespaces).text.should eq("Research Guide")
    doc.at_xpath('oai:OAI-PMH/oai:ListRecords/oai:record/oai:metadata/oai_dc:dc/dc:identifier', namespaces).text.should eq("http://guides.nyu.edu/content.php?pid=38898")
    doc.at_xpath('oai:OAI-PMH/oai:ListRecords/oai:record/oai:metadata/oai_dc:dc/dc:publisher', namespaces).text.should eq("[New Delhi]:United Nations Development Programme (UNDP), India,2010-12")
    doc.at_xpath('oai:OAI-PMH/oai:ListRecords/oai:record/oai:metadata/oai_dc:dc/dc:date', namespaces).text.should eq("2014-08-18 04:17:34 PM")
    doc.at_xpath('oai:OAI-PMH/oai:ListRecords/oai:record/oai:metadata/oai_dc:dc/dc:type', namespaces).text.should eq("Research Guide")
  end
end
