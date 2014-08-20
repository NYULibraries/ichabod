# Dummy up an NYUcore record for Fedora ingestion
# Note that every test that uses this factory will have to be wrapped
# in a VCR cassette since saving Fedora records in Hydra requires an http call
FactoryGirl.define do

  factory Nyucore do

    trait :valid_record do
      title "A Star Wars Guide to Fun in the Sun"
      creator "The Man"
      publisher "NYU"
      available ["Avail 1","Travail"]
      description ["Interesting topic","But poorly written"]
      edition ["Ed 1","Edition 1"]
      series ["Series 1","Series I"]
      version ["V1","Latest Version"]
      date ["12/05/2014","04/01/1666"]
      format ["PDF","DNS"]
      language ["en","ger"]
      relation ["x is to y as y is to z","one and a two and a"]
      rights ["remain silent","hire an attorney"]
      subject ["Cryptozoology","Vexillology"]
    end

    trait :type do
      type "Dataset"
    end

    trait :valid_citation do
      citation ["Shouldn't have jumped the turnstile","Shouldn't have ran a red light"]
    end

    trait :valid_gis_type do
      type "Geospatial Data"
    end

    trait :invalid_citation do
      citation "J E T S Jettison"
    end

    trait :valid_identifier do
      identifier "rec123"
    end

    trait :invalid_identifier do
      identifier ["First Id","Superego"]
    end

    trait :another_valid_record do
      title "new title"
      creator "new creator"
      publisher "new publisher"
      available ["new available"]
      type "new type"
      description ["new description"]
      edition ["new edition"]
      series ["new series"]
      version ["new version"]
      date ["new date"]
      format ["new format"]
      language ["new language"]
      relation ["new relation"]
      rights ["new rights"]
      subject ["new subject"]
      citation ["new citation"]
      identifier "new identifier"
    end

    trait :cymbeline do
      title "Cymbeline"
    end

    trait :the_tempest do
      title "The Tempest"
    end

    factory :another_valid_nyucore, traits: [:another_valid_record]
    factory :cymbeline, traits: [:another_valid_record, :cymbeline]
    factory :the_tempest, traits: [:another_valid_record, :the_tempest]
    factory :valid_nyucore, traits: [:valid_record, :type, :valid_citation, :valid_identifier]
    factory :invalid_nyucore_citation, traits: [:valid_record, :type, :invalid_citation, :valid_identifier]
    factory :invalid_nyucore_id, traits: [:valid_record, :type, :valid_citation, :invalid_identifier]

    factory :valid_gis_record do
      valid_record
      valid_gis_type
      valid_citation
      valid_identifier
      after(:build) {|record| record.set_edit_groups(['gis_cataloger'],[]) }
      # Don't dare put an underscore in this pid or it'll explode
      initialize_with { new(pid: 'testgisrecord:123') }
    end

  end

end
