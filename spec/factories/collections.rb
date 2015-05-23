
# Dummy up an Collection record for Fedora ingestion
# Note that every test that uses this factory will have to be wrapped
# in a VCR cassette since saving Fedora records in Hydra requires an http call
FactoryGirl.define do
  sequence(:title) { |n| "title#{n}" }

  factory :collection do
    title "Collection of records"
    creator ["Special Collections"]
    description "We need to test how collection works"
    rights "rights1"
    publisher ["DLTS"]
    discoverable "1"
    after(:build) { |record| record.set_edit_groups(['admin_group'],[]) }
  end
end
