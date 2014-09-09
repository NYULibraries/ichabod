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
    context "when object contains ESRI as publisher and Geospatial Data as type" do
      it { should include "ESRI" }
      it { should include "Spatial Data Repository" }
    end
    context "when object contains ESRI as publisher and no type" do
      let(:type) { nil }
      it { should include "ESRI" }
      it { should_not include "Spatial Data Repository" }
    end
    context "when object contains Geospatial Data as type and no publisher" do
      let(:publisher) { nil }
      it { should_not include "ESRI" }
      it { should include "Spatial Data Repository" }
    end
    context "when object contains Geospatial Data as publisher and ESRI as type" do
      let(:publisher) { "Geospatial Data" }
      let(:type) { "ESRI" }
      it { should be_empty }
    end
    context "when object contains ESRI and something else in publisher" do
      let(:publisher) { ["ESRI", "something else" ]}
      let(:type) { nil }
      it { should eql ["ESRI"] }
    end
    context "when object contains Geospatial Data and something else in type" do
      let(:type) { ["Geospatial Data", "something else" ]}
      let(:publisher) { nil }
      it { should eql ["Spatial Data Repository"] }
    end
    context "when object is from the Rosie the Riveter resource set" do
      let(:type) { ['Video'] }
      let(:publisher) { nil }
      let(:resource_set) { ['rosie_the_riveter'] }
      it { should eql ['The Real Rosie the Riveter'] }
    end
  end
end
