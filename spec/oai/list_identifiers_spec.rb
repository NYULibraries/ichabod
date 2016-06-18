require 'spec_helper'

describe "ListIdentifiers", :type => :oai do

  before do
    get "oai?verb=ListIdentifiers"
  end  
 
    it "responds to a list identifiers request" do
      last_response.status.should eql(200)
      doc = Nokogiri::XML(last_response.body)
      namespaces = { 'oai' => 'http://www.openarchives.org/OAI/2.0/',
               'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/',
               'dc' => 'http://purl.org/dc/elements/1.1/'
             } 
      
      doc.xpath('oai:OAI-PMH/oai:ListIdentifiers/oai:header', namespaces).should have(25).items
      doc.xpath('oai:OAI-PMH/oai:ListIdentifiers/oai:header[position()=1]/oai:identifier', namespaces).text.should eq("/libguides:guides-nyu-edu-content-php-pid-38898")
      doc.xpath('oai:OAI-PMH/oai:ListIdentifiers/oai:header[position()=2]/oai:identifier', namespaces).text.should eq("/libguides:localhost")
      doc.xpath('oai:OAI-PMH/oai:ListIdentifiers/oai:header[position()=3]/oai:identifier', namespaces).text.should eq("/fda:hdl-handle-net-2451-33612")
      
      resumptionToken = 
        doc.xpath('oai:OAI-PMH/oai:ListIdentifiers/oai:resumptionToken', namespaces).text  
        #resumptionToken.should eq("oai_dc.f(2016-06-18T17:25:32Z).u(2016-06-18T17:25:44Z):25")
    
      puts "Resumption Token: " + resumptionToken
      get "oai?verb=ListIdentifiers&resumptionToken=" + resumptionToken
      last_response.status.should eql(200)
      doc = Nokogiri::XML(last_response.body)
    
      doc.xpath('oai:OAI-PMH/oai:ListIdentifiers/oai:header', namespaces).should have(2).items
      doc.xpath('oai:OAI-PMH/oai:ListIdentifiers/oai:header[position()=1]/oai:identifier', namespaces).text.should eq("/masses:masses010")
      doc.xpath('oai:OAI-PMH/oai:ListIdentifiers/oai:header[position()=2]/oai:identifier', namespaces).text.should eq("/masses:masses011")     
    
    end

end