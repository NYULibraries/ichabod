require 'spec_helper'

describe CollectionsHelper do
  let(:collection) { build(:collection) }
  before { assign(:collection, collection) }

  describe '#single_collection_fields' do
    subject { helper.single_collection_fields }
    it { should be_an Array }
  end

  describe '#single_fields' do
    subject { helper.single_fields }
    it { should be_an Array }
  end

  describe '#multiple_fields' do
    subject { helper.multiple_collection_fields }
    it { should be_an Array }
  end

  describe '#admin_fields' do
    subject { helper.admin_collection_fields }
    it { should be_an Array }
  end

  describe '#required_fields' do
    subject { helper.required_collection_fields }
    it { should be_an Array }
  end

  describe '#get_boolean' do
    let(:value) {  }
    subject { helper.get_boolean(value) }
    context 'it should return true if the value is blank' do
      it { should eq true }
    end
    context 'it should return true if the value is  equal to 1' do
      let(:value) { '1' }
      it { should eq true }
    end
    context 'it should return false if the value is  equal to 0' do
      let(:value) { '0' }
      it { should eq false }
    end
  end


  describe "#format_boolean_value" do
    let(:value) { '1' }
    let(:field) { 'discoverable' }
    subject { helper.format_boolean_value(value,field) }
    context 'it should return Yes if discoverable field is set to true' do
      it { should eq 'Yes' }
    end
    context 'it should return Yes if discoverable field is set to false' do
      let(:value) { '0' }
      let(:field) { 'discoverable' }
      it { should eq 'No' }
    end
    context 'it should return value for other fields' do
      let(:value) { 'Collection of records' }
      let(:field) { 'title' }
      it { should eq 'Collection of records' }
    end
  end
end
