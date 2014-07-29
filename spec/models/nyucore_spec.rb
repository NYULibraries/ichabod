require 'spec_helper'

describe Nyucore, vcr: { cassette_name: "check nyucore schema" } do

  let(:nyucore) { create(:valid_nyucore) }

  it "should have one or more title fields" do
    expect(nyucore.title).to_not be_empty
    expect(nyucore.title).to be_instance_of(Array)
  end

  it "should have one or more creator fields" do
    expect(nyucore.creator).to_not be_empty
    expect(nyucore.creator).to be_instance_of(Array)
  end

  it "should have one or more publisher fields" do
    expect(nyucore.publisher).to_not be_empty
    expect(nyucore.publisher).to be_instance_of(Array)
  end

  it "should have one or more available fields" do
    expect(nyucore.available).to_not be_empty
    expect(nyucore.available).to be_instance_of(Array)
    expect(nyucore.available.count).to be > 1
  end

  it "should have one or more type fields" do
    expect(nyucore.type).to_not be_empty
    expect(nyucore.type).to be_instance_of(Array)
  end

  it "should have one or more description fields" do
    expect(nyucore.description).to_not be_empty
    expect(nyucore.description).to be_instance_of(Array)
    expect(nyucore.description.count).to be > 1
  end

  it "should have one or more edition fields" do
    expect(nyucore.edition).to_not be_empty
    expect(nyucore.edition).to be_instance_of(Array)
    expect(nyucore.edition.count).to be > 1
  end

  it "should have one or more series fields" do
    expect(nyucore.series).to_not be_empty
    expect(nyucore.series).to be_instance_of(Array)
    expect(nyucore.series.count).to be > 1
  end

  it "should have one or more version fields" do
    expect(nyucore.version).to_not be_empty
    expect(nyucore.version).to be_instance_of(Array)
    expect(nyucore.version.count).to be > 1
  end

  it "should have one or more format fields" do
    expect(nyucore.format).to_not be_empty
    expect(nyucore.format).to be_instance_of(Array)
    expect(nyucore.format.count).to be > 1
  end

  it "should have one or more date fields" do
    expect(nyucore.date).to_not be_empty
    expect(nyucore.date).to be_instance_of(Array)
    expect(nyucore.date.count).to be > 1
  end

  it "should have one or more language fields" do
    expect(nyucore.language).to_not be_empty
    expect(nyucore.language).to be_instance_of(Array)
    expect(nyucore.language.count).to be > 1
  end

  it "should have one or more relation fields" do
    expect(nyucore.relation).to_not be_empty
    expect(nyucore.relation).to be_instance_of(Array)
    expect(nyucore.relation.count).to be > 1
  end

  it "should have one or more rights fields" do
    expect(nyucore.rights).to_not be_empty
    expect(nyucore.rights).to be_instance_of(Array)
    expect(nyucore.rights.count).to be > 1
  end

  it "should have one or more subject fields" do
    expect(nyucore.subject).to_not be_empty
    expect(nyucore.subject).to be_instance_of(Array)
    expect(nyucore.subject.count).to be > 1
  end

  describe "identifier attribute" do

    subject { nyucore.identifier }

    context "when identifier is correctly passed in as string" do
      it { should_not be_empty }
      it { should be_instance_of String }
    end

    context "when identifier is incorrectly passed in as array" do
      let(:nyucore) { create(:invalid_nyucore_id) }
      it { should be_instance_of String }
      it { should eq attributes_for(:invalid_nyucore_id)[:identifier].first }
    end

  end

  describe "citation attribute" do

    subject { nyucore.citation }

    context "when citation is correctly passed in as an array" do
      it { should_not be_empty}
      it { should be_instance_of Array }
      it { expect(subject.count).to be > 1 }
    end

    context "when citation is incorrectly passed in as a string" do
      let(:nyucore) { create(:invalid_nyucore_citation) }
      it { should be_instance_of Array }
      it { expect(subject.count).to be 1 }
      it { should eq [attributes_for(:invalid_nyucore_citation)[:citation]] }
    end

  end

end
