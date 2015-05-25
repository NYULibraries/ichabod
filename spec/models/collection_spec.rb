require 'spec_helper'

describe Collection do

describe Collection::COLLECTION_FIELDS do
    subject { Collection::COLLECTION_FIELDS }
    it { should be_a Hash }
    it { should have_key :single }
    it { should have_key :multiple }
    it 'should have the appropriate single fields' do
      expect(subject[:single]).to eq [ :title,:description,:rights ]
    end
    it 'should have the appropriate multiple fields' do
      expect(subject[:multiple]).to eq [ :creator, :publisher ]
    end
  end

  describe Collection::FIELDS do
    subject { Collection::FIELDS }
    it { should eq Collection::SINGLE_FIELDS+Collection::MULTIPLE_FIELDS+Collection::WORKFLOW_FIELDS }
  end

  describe Collection::WORKFLOW_FIELDS do
    subject { Collection::WORKFLOW_FIELDS }
    it { should eq [:discoverable] }
  end

  describe Collection::REQUIRED_FIELDS do
    subject { Collection::REQUIRED_FIELDS }
    it { should eq [:title, :discoverable] }
  end

  describe Collection::MULTIPLE_FIELDS do
    subject { Collection::MULTIPLE_FIELDS }
    it { should eq [:creator, :publisher ] }
  end

  describe Collection::SINGLE_FIELDS do
    subject { Collection::SINGLE_FIELDS }
    it { should eq [:title, :description, :rights, :discoverable] }
  end

  subject(:collection) { build(:collection) }
  # Generic test for validity
  it { should be_valid }
  

  describe '#collection_metadata' do
    subject { collection.collection_metadata }
    it { should be_a Ichabod::NyucoreDatastream }
  end

  describe '#workflow_metadata' do
    subject { collection.workflow_metadata }
    it { should be_a Ichabod::WorkflowDatastream }
  end

  #Test that we do presence test for required field

  Collection::REQUIRED_FIELDS.each do |field|
  it { should validate_presence_of :"#{field}"}
  end


     # Some meta programming to test all the single-valued Collection attributes
  Collection::SINGLE_FIELDS.each do |field|
    # Generic test for validity
    it { should be_valid }
    # Generic test for presence
    its(field) { should be_present }

    # Test the attribute writers
    describe "##{field}=" do
      let(:value) { "#{field}" }
      let(:collection) { build(:collection, field => value) }
      it "should set the #{field} attribute" do
        expect(collection.send(field)).to be_present
        expect(collection.send(field)).to eq value
      end
      it "should set the #{field} attribute in the collection_metadata datastream" do
        expect(collection.collection_metadata.send(field)).to be_present
        expect(collection.collection_metadata.send(field)).to eq [value]
      end
      context 'when the value is incorrectly passed in as an Array' do
        let(:value) { ['1', '2'] }
        it "should get the #{field} attribute as a String" do
          expect(collection.send(field)).to be_present
          expect(collection.send(field)).to eq value.first
        end
      end
      context 'when the value is correctly passed in as a String' do
        let(:value) { '1' }
        it "should get the #{field} attribute as a String" do
          expect(collection.send(field)).to be_present
          expect(collection.send(field)).to eq value
        end
      end
    end


    describe "##{field}" do
      let(:value) { 'value' }
      subject { collection.send(field) }
      it { should be_present }
      it { should be_a String }
      context 'when there is collection metadata' do
        before { collection.collection_metadata.send("#{field}=", value) }
          it { should eq value }
        end
    end

  # Test that the fields get set correctly at initialization
    context "when the #{field} value is set at initialization" do
      subject { build(:collection, field => value) }
      context "and the value is a String" do
        let(:value) { '1' }
        its(field) { should be_present }
        its(field) { should be_a String }
        its(field) { should eq value }
      end
      context "and the value is an Array" do
        let(:value) { ['1', '2'] }
        its(field) { should be_present }
        its(field) { should be_a String }
        its(field) { should eq value.first }
      end
    end
  end

  # Some meta programming to test all the multi-valued Collection attributes and
  # extra Ichabod attributes
  Collection::MULTIPLE_FIELDS.each do |field|
    # Generic test for validity
    it { should be_valid }
    # Generic test for presence
    its(field) { should be_present }

    # Test the attribute writers
    describe "##{field}=" do
      let(:value) { "#{field}" }
      let(:collection) { build(:collection, field => value) }
      it "should set the #{field} attribute" do
        expect(collection.send(field)).to be_present
        expect(collection.send(field)).to eq [value]
      end
      it "should set the #{field} attribute in the collection_metadata datastream" do
        expect(collection.collection_metadata.send(field)).to be_present
        expect(collection.collection_metadata.send(field)).to eq [value]
      end
      context 'when the value is correctly passed in as an Array' do
        let(:value) { ['1', '2'] }
        it "should set the #{field} attribute as an Array" do
          expect(collection.send(field)).to be_present
          expect(collection.send(field)).to eq value
        end
      end
      context 'when the value is incorrectly passed in as a String' do
        let(:value) { '1' }
        it "should set the #{field} attribute as an Array" do
          expect(collection.send(field)).to be_present
          expect(collection.send(field)).to eq [value]
        end
      end
    end

    # Test the attribute readers
    describe "##{field}" do
      let(:value) { 'value' }
      subject { collection.send(field) }
      it { should be_present }
      it { should be_an Array }
      context 'when there is collection metadata' do
        before { collection.collection_metadata.send("#{field}=", value) }
        its(:first) { should eq value }
      end
    end

    # Test that the fields get set correctly at initialization
    context "when the #{field} value is set at initialization" do
      let(:value) { "#{field}" }
      subject { build(:collection, field => value) }
      it { should be_valid }
      its(field) { should be_present }
      its(field) { should be_an Array }
      its(field) { should include value }
      it "should set the #{field} attribute in the collection_metadata datastream" do
        expect(subject.collection_metadata.send(field)).to be_present
        expect(subject.collection_metadata.send(field)).to include value
      end
      context "and the value is an Array" do
        let(:value) { ['1', '2'] }
        its(field) { should be_present }
        its(field) { should be_an Array }
        its(field) { should eq value }
      end
      context "and the value is a String" do
        let(:value) { '1' }
        its(field) { should be_present }
        its(field) { should be_an Array }
        its(field) { should eq [value] }
      end
    end
   

  end

end


