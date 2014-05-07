FactoryGirl.define do

  factory Nyucore do
    title "My record"
    creator "The Man"
    publisher "NYU"
    identifier "rec123"
    available ["Not sure what this is"]
    type "Geospatial Dataset"
    description ["This is a record"]
    edition ["Ed 1"]
    series ["Series 1"]
    version ["V1"]
    date ["12/05/2014"]
    format ["some"]
    language ["en"]
  end

end
