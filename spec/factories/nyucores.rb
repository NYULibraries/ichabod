# Dummy up an NYUcore record for Fedora ingestion
# Note that every test that uses this factory will have to be wrapped
# in a VCR cassette since saving Fedora records in Hydra requires an http call
FactoryGirl.define do
  factory :nyucore do
    sequence(:identifier) { |n| "#{series.first}_#{n}" }
    title ["LION"]
    creator ["Hugh Plisher"]
    available ["http://library.nyu.edu"]
    description ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur non posuere lectus. In facilisis, arcu nec tempor vulputate, justo elit aliquet sapien, in tincidunt lorem purus eu nulla."]
    edition ["10C"]
    series ["NYCDCP_DCPLION_10CAV"]
    version ["DSS.NYCDCP_DCPLION_10cav\DSS.BOLIVAR"]
    isbn ["987654321099"]
    date ["12/05/2014","04/01/1666"]
    type ["Rosie Stuff"]
    language ["English"]
    relation ["relation1"]
    rights ["rights1"]
    subject ["vexillology"]
    publisher ["Rosie"]
    format ["ZIP"]
    citation ["Cite", "Me"]
    addinfotext ["Ask a Librarian"]
    addinfolink ["http://library.nyu.edu/ask"]
    resource_set 'resource_set'
    repo 'Fales'
    restrictions 'NYU Only'
    data_provider ["NYU"] 
    geometry ["line"] 
    subject_spatial ["Buenos Aires"]
    subject_temporal ["2013"]
    location ["Box: 2, Folder: 3"]
    genre ["Postcards"]
    after(:build) { |record| record.set_edit_groups(['admin_group'],[]) }

    factory :gis_record do
      after(:build) { |record| record.set_edit_groups(['gis_cataloger'],[]) }
      # Don't dare put an underscore in this pid or it'll explode
      initialize_with { new(pid: 'testgisrecord:123') }
    end
  end
end
