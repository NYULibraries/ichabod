require 'spec_helper'

describe Nyucore::Collections do

  let(:nyucore) { build(:nyucore, type: "Geospatial Data", publisher: "ESRI") }
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
    it { should include "ESRI" }
    it { should include "Spatial Data Repository" }
  end

end
