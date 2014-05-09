# Dummy up an NYUcore record for Fedora ingestion
# Note that every test that uses this factory will have to be wrapped
# in a VCR cassette since saving Fedora records in Hydra requires an http call
FactoryGirl.define do

  factory Nyucore do
    title "A Star Wars Guide to Fun in the Sun"
    creator "The Man"
    publisher "NYU"
    identifier "rec123"
    available ["Avail 1","Travail"]
    type "Geospatial Dataset"
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
    citation ["Shouldn't have jumped the turnstile","Shouldn't have ran a red light"]
  end

end
