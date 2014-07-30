require 'spec_helper'

describe Nyucore, vcr: { cassette_name: "check nyucore schema" } do

  let(:nyucore) { create(:nyucore) }
  subject { nyucore }

  its(:title) { should_not be_empty }
  its(:creator) { should_not be_empty }
  its(:publisher) { should_not be_empty }
  its(:available) { should_not be_empty }
  its(:type) { should_not be_empty }
  its(:description) { should_not be_empty }
  its(:edition) { should_not be_empty }
  its(:series) { should_not be_empty }
  its(:version) { should_not be_empty }
  its(:format) { should_not be_empty }
  its(:date) { should_not be_empty }
  its(:language) { should_not be_empty }
  its(:relation) { should_not be_empty }
  its(:rights) { should_not be_empty }
  its(:subject) { should_not be_empty }

  describe "#identifier" do

    subject { nyucore.identifier }

    context "when identifier is correctly passed in as string" do
      it { should_not be_empty }
      it { should be_instance_of String }
    end

    context "when identifier is incorrectly passed in as array" do
      let(:nyucore) { create(:nyucore, identifier: ["1234","5678"]) }
      it { should be_instance_of String }
      it { should eq "1234" }
    end

  end

  describe "#citation" do

    subject { nyucore.citation }

    context "when citation is correctly passed in as an array" do
      it { should_not be_empty }
      it { should be_instance_of Array }
      it { expect(subject.count).to be > 1 }
    end

    context "when citation is incorrectly passed in as a string" do
      let(:nyucore) { create(:nyucore, citation: "CiteMe") }
      it { should be_instance_of Array }
      it { expect(subject.count).to be 1 }
      it { should eq ["CiteMe"] }
    end

  end

  describe "#collections" do

    subject { nyucore.collections }

    context "when there are no collections to map to" do
      it { should be_empty }
    end

    context "when there are collections to map to from both the publisher and type fields" do
      let(:nyucore) { create(:nyucore, type: "Geospatial Data", publisher: "ESRI") }
      it { should include "ESRI" }
      it { should include "Spatial Data Repository" }
    end

    context "when there are collections to map to from the type field" do
      let(:nyucore) { create(:nyucore, type: "Geospatial Data") }
      it { should include "Spatial Data Repository" }
      it { should_not include "ESRI" }
    end

    context "when there are collections to map to from the publisher field" do
      let(:nyucore) { create(:nyucore, publisher: "ESRI") }
      it { should include "ESRI" }
      it { should_not include "Spatial Data Repository" }
    end

  end

end
