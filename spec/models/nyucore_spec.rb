require 'spec_helper'

describe Nyucore, vcr: { cassette_name: "nyucore create new" } do

  let(:nyucore) { create(:nyucore) }

  it "should have a single title field" do
    expect(nyucore.title).to_not be_nil
    expect(nyucore.title).to_not be_nil;
    expect(nyucore.title).to be_instance_of(String)
  end

  it "should have a single creator field" do
    expect(nyucore.creator).to_not be_nil
    expect(nyucore.creator).to be_instance_of(String)
  end

  it "should have a single publisher field" do
    expect(nyucore.publisher).to_not be_nil
    expect(nyucore.publisher).to be_instance_of(String)
  end

  it "should have a single identifier field" do
    expect(nyucore.identifier).to_not be_nil
    expect(nyucore.identifier).to be_instance_of(String)
  end

  it "should have one or more available fields" do
    expect(nyucore.available).to_not be_nil
    expect(nyucore.available).to be_instance_of(Array)
    expect(nyucore.available.count).to be > 1
  end

  it "should have a single type field" do
    expect(nyucore.type).to_not be_nil
    expect(nyucore.type).to be_instance_of(String)
  end

  it "should have one or more description fields" do
    expect(nyucore.description).to_not be_nil
    expect(nyucore.description).to be_instance_of(Array)
    expect(nyucore.description.count).to be > 1
  end

  it "should have one or more edition fields" do
    expect(nyucore.edition).to_not be_nil
    expect(nyucore.edition).to be_instance_of(Array)
    expect(nyucore.edition.count).to be > 1
  end

  it "should have one or more series fields" do
    expect(nyucore.series).to_not be_nil
    expect(nyucore.series).to be_instance_of(Array)
    expect(nyucore.series.count).to be > 1
  end

  it "should have one or more version fields" do
    expect(nyucore.version).to_not be_nil
    expect(nyucore.version).to be_instance_of(Array)
    expect(nyucore.version.count).to be > 1
  end

  it "should have one or more format fields" do
    expect(nyucore.format).to_not be_nil
    expect(nyucore.format).to be_instance_of(Array)
    expect(nyucore.format.count).to be > 1
  end

  it "should have one or more date fields" do
    expect(nyucore.date).to_not be_nil
    expect(nyucore.date).to be_instance_of(Array)
    expect(nyucore.date.count).to be > 1
  end

  it "should have one or more language fields" do
    expect(nyucore.language).to_not be_nil
    expect(nyucore.language).to be_instance_of(Array)
    expect(nyucore.language.count).to be > 1
  end

  it "should have one or more relation fields" do
    expect(nyucore.relation).to_not be_nil
    expect(nyucore.relation).to be_instance_of(Array)
    expect(nyucore.relation.count).to be > 1
  end

  it "should have one or more rights fields" do
    expect(nyucore.rights).to_not be_nil
    expect(nyucore.rights).to be_instance_of(Array)
    expect(nyucore.rights.count).to be > 1
  end

  it "should have one or more subject fields" do
    expect(nyucore.subject).to_not be_nil
    expect(nyucore.subject).to be_instance_of(Array)
    expect(nyucore.subject.count).to be > 1
  end

  it "should have one or more citation fields" do
    expect(nyucore.citation).to_not be_nil
    expect(nyucore.citation).to be_instance_of(Array)
    expect(nyucore.citation.count).to be > 1
  end

end
