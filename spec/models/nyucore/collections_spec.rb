require 'spec_helper'

describe Nyucore::Collections do

  let(:type) { "Geospatial Data" }
  let(:publisher) { "ESRI" }
  let(:resource_set) { "spatial_data_repository" }
  let(:attributes) do
    {type: type, publisher: publisher, resource_set: resource_set}
  end
  let(:nyucore) { build(:nyucore, attributes) }
  let(:nyucore_collections) { Nyucore::Collections.new(nyucore) }

  describe ".new" do
    subject { nyucore_collections }
    context "when argument is an nyucore object" do
      it "should not raise an exception" do
        expect { subject }.to_not raise_error
      end
    end
    context "when argument is not an nyucore object" do
      let(:nyucore) { build(:user) }
      it "should raise an exception" do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe "#to_a" do
    subject { nyucore_collections.to_a }
    it { should be_instance_of Array }
    context "when object contains Geospatial Data in type" do
      let(:type) { ["Geospatial Data"]}
      let(:publisher) { nil }
      it { should eql ["Spatial Data Repository"] }
    end
    context "when object is from the Rosie the Riveter resource set" do
      let(:type) { ['Video'] }
      let(:publisher) { nil }
      let(:resource_set) { ['rosie_the_riveter'] }
      it { should eql ['The Real Rosie the Riveter'] }
    end
    context "when object is from the Voices of the Food Revolution resource set" do
      let(:type) { ['Audio'] }
      let(:publisher) { nil }
      let(:resource_set) { ['voice'] }
      it { should eql ['Voices of the Food Revolution'] }
    end
    context "when object is FDA NGO resource set" do
      let(:type) { ['Report'] }
      let(:publisher) { nil }
      let(:resource_set) { ['faculty_digital_archive_ngo'] }
      it { should eql ['South Asian NGOs and other reports'] }
    end
    context "when object is from the Archive of Contemporary Composers' Websites resource set" do
      let(:type) { nil }
      let(:publisher) { nil }
      let(:resource_set) { ['archive_it_accw'] }
      it { should eql ["Archive of Contemporary Composers' Websites"] }
    end
    context "when object is from the NYUPress Open Access Books resource set" do
      let(:type) { ['Book'] }
      let(:publisher) { nil }
      let(:resource_set) { ['nyu_press_open_access_book'] }
      it { should eql ['NYU Press Open Access Books'] }
    end
    context "when object is FDA Data Service resource set" do
      let(:type) { ['DataSet'] }
      let(:publisher) { nil }
      let(:resource_set) { ['faculty_digital_archive_service_data'] }
      it { should eql ['Data Services'] }
    end
    context "when object is from the Research Guides resource set" do
      let(:type) { ['Research Guide'] }
      let(:publisher) { nil }
      let(:resource_set) { ['lib_guides'] }
      it { should eql ['Research Guides'] }
    end
  end
end
