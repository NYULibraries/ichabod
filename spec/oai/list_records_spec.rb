require 'spec_helper'

describe "ListRecords", :type => :oai do

  it "responds correctly to a ListRecords request" do
    get "oai?verb=ListRecords&metadataPrefix=oai_dc"
    last_response.status.should eql(200)
    doc = Nokogiri::XML(last_response.body)
    #doc.at('OAI-PMH/ListRecords/record/header/identifier').text.should eq("/libguides:guides-nyu-edu-content-php-pid-38898")
    #doc.at('OAI-PMH/ListRecords/record/header/identifier').text.should eq("DSS.NYCDCP_DCPLION_10cav\DSS-Lion_GJK")
    
    namespaces = { 'oai' => 'http://www.openarchives.org/OAI/2.0/',
               'oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/',
               'dc' => 'http://purl.org/dc/elements/1.1/'
             }   
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record', namespaces).should have(25).items
    
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=3]/oai:metadata/oai_dc:dc/dc:type', namespaces).text.should eq("Report")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=3]/oai:metadata/oai_dc:dc/dc:creator', namespaces).text.should eq("Chakrapani, VenkatesanUnited Nations Development Programme (UNDP), India")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=3]/oai:metadata/oai_dc:dc/dc:title', namespaces).text.should eq("Hijras/transgender women in India: HIV, human rights and social exclusion")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=3]/oai:metadata/oai_dc:dc/dc:description', namespaces).text.should eq("The focus of this Transgender Issue Brief is to summarize the various issues faced by Hijras and transgender women.")
    
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=15]/oai:metadata/oai_dc:dc/dc:type', namespaces).text.should eq("Dataset")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=15]/oai:metadata/oai_dc:dc/dc:creator', namespaces).text.should eq("Oak Ridge National LaboratoryEast View Geospatial (Firm)")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=15]/oai:metadata/oai_dc:dc/dc:title', namespaces).text.should eq("East View Geospatial LandScan global archive")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=15]/oai:metadata/oai_dc:dc/dc:identifier', namespaces).text.should eq("http://hdl.handle.net/2451/33839")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=15]/oai:metadata/oai_dc:dc/dc:publisher', namespaces).text.should eq("Oak Ridge National Laboratory")
    
    #doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record/oai:metadata/oai_dc:dc/dc:type', namespaces).text.should eq("Research GuideResearch GuideReportReportReportReportReportBookBookBookBookBookDatasetDatasetDatasetDatasetDocumentBookBookBookBookBook")
    #doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record/oai:metadata/oai_dc:dc/dc:creator', namespaces).text.should eq("Samantha GussNAMEChakrapani, VenkatesanUnited Nations Development Programme (UNDP), IndiaHamsafar TrustVerma, Jagdish SharanSeth, LeilaSubramanian, GopalJustice J.S. Verma CommitteeCommittee on Amendments to Criminal LawSwaminathan, HemaBhatla, NanditaChakraborty, SwatiKidd, RossPrasad, NandiniAvula, JyothsnaTajuddin, MirzaJody David ArmourMarshall W. Alcorn Jr.Natalie Clifford Barney, John Spalding GattonEllen E. BerryKathleen L. BarryOak Ridge National LaboratoryEast View Geospatial (Firm)Thomas Seltzer, Jan.-Apr. 1911Horatio Winslow, May-Dec. 1911  Piet Vlag, Jan.-Aug. 1912Max Eastman, Dec. 1912-1917Thomas Seltzer, Jan.-Apr. 1911Horatio Winslow, May-Dec. 1911  Piet Vlag, Jan.-Aug. 1912Max Eastman, Dec. 1912-1917Thomas Seltzer, Jan.-Apr. 1911Horatio Winslow, May-Dec. 1911  Piet Vlag, Jan.-Aug. 1912Max Eastman, Dec. 1912-1917Thomas Seltzer, Jan.-Apr. 1911Horatio Winslow, May-Dec. 1911  Piet Vlag, Jan.-Aug. 1912Max Eastman, Dec. 1912-1917Thomas Seltzer, Jan.-Apr. 1911Horatio Winslow, May-Dec. 1911  Piet Vlag, Jan.-Aug. 1912Max Eastman, Dec. 1912-1917")
    #doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record/oai:metadata/oai_dc:dc/dc:identifier', namespaces).text.should eq("http://guides.nyu.edu/content.php?pid=38898http://localhosthttp://hdl.handle.net/2451/33612http://www.undp.org/content/dam/india/docs/hijras_transgender_in_india_hiv_human_rights_and_social_exclusion.pdfhttp://hdl.handle.net/2451/33613http://humsafar.org/ResDown/RESEARCH%20Building%20evidence%20around%20adolescent%20same-sex%20behavior%20and%20vulnerability%20to%20HIV%20-%202013.pdfhttp://hdl.handle.net/2451/33614http://csrindia.org/images/download/Amendments-To-Criminal-Law.pdfhttp://hdl.handle.net/2451/33615http://www.icrw.org/files/publications/Womens-Property-Rights-as-an-AIDS-Response-Emerging-Efforts-in-South-Asia.pdfhttp://hdl.handle.net/2451/33616http://www.icrw.org/files/publications/Reducing-HIV-Stigma-and-Gender-Based-Violence-Toolkit-for-Health-Care-Providers-in-India.pdf97808147064049780814706657978081471177497808147124819780814712771http://hdl.handle.net/2451/33978http://hdl.handle.net/2451/33892http://hdl.handle.net/2451/33839http://hdl.handle.net/2451/33823http://hdl.handle.net/2451/33822masses001masses002masses003masses004masses005")
    #doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record/oai:metadata/oai_dc:dc/dc:publisher', namespaces).text.should eq("[New Delhi]:United Nations Development Programme (UNDP), India,2010-12Mumbai:Humsafar Trust,2013New Delhi:Government of India, Committee on Amendments to Criminal Law,2013-01-23Washington, DC:Washington, DC : International Center for Research on Women (ICRW),2007Washington, DC:International Center for Research on Women (ICRW),2007Oak Ridge National LaboratoryUniversity of Michigan China Data CenterSindh Archives, Government of Sindh")
        
    resumptionToken = 
      doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:resumptionToken', namespaces).text  
      #resumptionToken.should eq("TEST")
    
    puts "Resumption Token: " + resumptionToken
    get "oai?verb=ListRecords&resumptionToken=" + resumptionToken
    last_response.status.should eql(200)
    doc = Nokogiri::XML(last_response.body)
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record', namespaces).should have(2).items
    
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=1]/oai:metadata/oai_dc:dc/dc:type', namespaces).text.should eq("Book")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=1]/oai:metadata/oai_dc:dc/dc:creator', namespaces).text.should eq("Thomas Seltzer, Jan.-Apr. 1911Horatio Winslow, May-Dec. 1911  Piet Vlag, Jan.-Aug. 1912Max Eastman, Dec. 1912-1917")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=1]/oai:metadata/oai_dc:dc/dc:title', namespaces).text.should eq("The Masses (masses010) Vol. 1, No. 10, October 1911")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=1]/oai:metadata/oai_dc:dc/dc:description', namespaces).text.should eq("Vol. 1, No. 10, October 1911")

    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=2]/oai:metadata/oai_dc:dc/dc:type', namespaces).text.should eq("Book")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=2]/oai:metadata/oai_dc:dc/dc:creator', namespaces).text.should eq("Thomas Seltzer, Jan.-Apr. 1911Horatio Winslow, May-Dec. 1911  Piet Vlag, Jan.-Aug. 1912Max Eastman, Dec. 1912-1917")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=2]/oai:metadata/oai_dc:dc/dc:title', namespaces).text.should eq("The Masses (masses011) Vol. 1, No. 11, November 1911")
    doc.xpath('oai:OAI-PMH/oai:ListRecords/oai:record[position()=2]/oai:metadata/oai_dc:dc/dc:description', namespaces).text.should eq("Vol. 1, No. 11, November 1911")
  
  end

end  



