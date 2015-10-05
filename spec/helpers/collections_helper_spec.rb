require 'spec_helper'

describe CollectionsHelper do
  let(:collection) { build(:collection) }
  before { assign(:collection, collection) }

  describe '#single_fields' do
    subject { helper.single_fields }
    it { should be_an Array }
  end

  describe '#single_collection_fields' do
    subject { helper.single_collection_fields }
    it { should be_an Array }
  end

  describe '#multiple_fields' do
    subject { helper.multiple_fields }
    it { should be_an Array }
  end

  describe '#admin_fields' do
    subject { helper.admin_fields }
    it { should be_an Array }
  end

  describe '#collection_fields' do
    subject { helper.collection_fields }
    it { should be_an Array }
  end

  describe '#required_fields' do
    subject { helper.required_fields }
    it { should be_an Array }
  end

  describe '#get_boolean' do
    subject { helper.get_boolean(value) }
    context "when value is blank" do
        let(:value) { nil }
        it { should be true }
    end
    context "when value is 1" do
        let(:value) { '1' }
        it { should be true }
    end
    context "when value is 0" do
        let(:value) { '0' }
        it { should be false }
    end 
  end

  describe '#format_boolean_value' do
    subject { helper.format_boolean_value(value,field) }
     context "when field is equal to discoverable" do
         let(:field) { :discoverable }
         context "when value is 1" do          
           let(:value) { '1' }
           it { should eq 'Yes' }
         end
         context "when value is 0" do
           let(:value) { '0' }
           it { should eq 'No' }
         end
     end 
     context "when field is not equal to discoverable" do
       let(:field) {:title }
       let(:value) { 'title_value' }
       it { should eq 'title_value' }
     end
  end

end
