require 'spec_helper'

describe Collection do


describe Collection::DESCRIPTIVE_FIELDS do
    subject { Collection::DESCRIPTIVE_FIELDS }
    it { should be_a Hash }
    it { should have_key :single }
    it { should have_key :multiple }
    it 'should have the appropriate single fields' do
      expect(subject[:single]).to eq [ :title,:description,:rights,:identifier ]
    end
    it 'should have the appropriate multiple fields' do
      expect(subject[:multiple]).to eq [ :creator, :publisher ]
    end
  end

  describe 'private_collections' do
    let(:collection_private) { create(:collection, :discoverable=>'0')  }
    let(:collection_public) { create(:collection, :discoverable=>'1')  }
    subject { Collection.private_collections }
    it { should include collection_private }
    it { should_not include collection_public }
  end

  describe 'has_records?' do
    subject { collection.has_records? }
      context ' When collection has related records' do
      let(:collection) {  Collection.find( { :desc_metadata__title_tesim=>'Indian Ocean Postcards' })[0]  }
        it { should be true }
      end
    context ' When collection has no related records' do
        let(:collection) { create(:collection) }
        it { should be false }
      end
  end

  describe Collection::FIELDS do
    subject { Collection::FIELDS }
    it { should eq Collection::SINGLE_FIELDS+Collection::MULTIPLE_FIELDS+Collection::ADMIN_FIELDS }
  end

  describe Collection::ADMIN_FIELDS do
    subject { Collection::ADMIN_FIELDS }
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
    it { should eq [:title, :description, :rights, :identifier, :discoverable] }
  end


    #Test that we do presence and uniqueness tests for required field
  
 
  subject(:collection) { build(:collection) }
  # Generic test for validity
  it { should be_valid }

  describe 'pid assignment' do
    context 'before the object is saved' do
      its 'pid should be nil' do
        expect(collection.pid).to be_nil
      end
    end
    context 'when a new object is saved' do
        before(:each) do
          collection.save
        end
        it 'should no longer be nil' do
          expect(collection.pid).not_to be_nil
        end
        it 'should include "ichabodcollection' do
          expect((collection.pid)).to include "ichabodcollection"
        end
     end
   end

  

  describe '#descriptive_metadata' do
    subject { collection.descriptive_metadata }
    it { should be_a Ichabod::NyucoreDatastream }
  end

  describe '#administrative_metadata' do
    subject { collection.administrative_metadata }
    it { should be_a Ichabod::AdministrativeDatastream }
  end

  context " when required fields are nil" do
   Collection::REQUIRED_FIELDS.each do |field|
     let(:value) { nil }
     subject(:collection) { build(:collection, field => value) }
     it { should_not be_valid}
   end
  end

 
     # Some meta programming to test all the single-valued Collection attributes
  Collection::DESCRIPTIVE_FIELDS[ :single ] .each do |field|
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
      it "should set the #{field} attribute in the descriptive_metadata datastream" do
        expect(collection.descriptive_metadata.send(field)).to be_present
        expect(collection.descriptive_metadata.send(field)).to eq [value]
      end
      context 'when the value is correctly passed in as a String' do
        let(:value) { "1" }
        it "should get the #{field} attribute as a String" do
          expect(collection.send(field)).to be_present
          expect(collection.send(field)).to eq value
        end
      end
    end


    describe "##{field}" do
      let(:value) { "value" }
      subject { collection.send(field) }
      it { should be_present }
      it { should be_a String }
      context 'when there is collection metadata' do
        before { collection.descriptive_metadata.send("#{field}=", value) }
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
    end
  end

 Collection::ADMIN_FIELDS.each do |field|
    # Generic test for validity
    it { should be_valid }
    # Generic test for presence
    its(field) { should be_present }

    # Test the attribute writers
    describe "##{field}=" do
      let(:value) { '0' }
      let(:collection) { build(:collection, field => value) }
      it "should set the #{field} attribute" do
        expect(collection.send(field)).to be_present
        expect(collection.send(field)).to eq value
      end
      it "should set the #{field} attribute in the administrative_metadata stream" do
        expect(collection.administrative_metadata.send(field)).to be_present
        expect(collection.administrative_metadata.send(field)).to eq [value]
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
      let(:value) { "1" }
      subject { collection.send(field) }
      it { should be_present }
      it { should be_a String }
      context 'when there is administrative metadata' do
        before { collection.administrative_metadata.send("#{field}=", value) }
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
      let(:value) { ["#{field}"] }
      let(:collection) { build(:collection, field => value ) }
      it "should set the #{field} attribute" do
        expect(collection.send(field)).to be_present
        expect(collection.send(field)).to eq value
      end
      it "should set the #{field} attribute in the descriptive_metadata datastream" do
        expect(collection.descriptive_metadata.send(field)).to be_present
        expect(collection.descriptive_metadata.send(field)).to eq value
      end
      context 'when the value is correctly passed in as an Array' do
        let(:value) { ['1', '2'] }
        it "should set the #{field} attribute as an Array" do
          expect(collection.send(field)).to be_present
          expect(collection.send(field)).to eq value
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
        before { collection.descriptive_metadata.send("#{field}=", value ) }
        its(:first) { should eq value }
      end
    end

    # Test that the fields get set correctly at initialization
    context "when the #{field} value is set at initialization" do
      let(:value) { ["#{field}"] }
      subject { build(:collection, field => value ) }
      it { should be_valid }
      its(field) { should be_present }
      its(field) { should be_an Array }
      its(field) { should include value.first }
      it "should set the #{field} attribute in the descriptive_metadata datastream" do
        expect(subject.descriptive_metadata.send(field)).to be_present
        expect(subject.descriptive_metadata.send(field)).to include value.first
      end
      context "and the value is an Array" do
        let(:value) { ['1', '2'] }
        its(field) { should be_present }
        its(field) { should be_an Array }
        its(field) { should eq value }
      end
    end


  end

end
