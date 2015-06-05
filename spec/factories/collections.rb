# Dummy up an Collection record for Fedora ingestion
# Note that every test that uses this factory will have to be wrapped
# in a VCR cassette since saving Fedora records in Hydra requires an http call
FactoryGirl.define do

  factory :collection do
    identifier "test_collection1"
    title "Collection of records"
    creator ["Special Collections"]
    publisher ["Special Collections","DLTS"]
    description "We need to test how collection works"
    rights "rights1"
    discoverable "1"
    after(:build) { |record| record.set_edit_groups(['admin_group'],[]) }
  end
end
