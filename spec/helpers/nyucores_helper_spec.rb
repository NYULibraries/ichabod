require "spec_helper"
describe NyucoresHelper do
  let(:item) { build(:nyucore) }
  before { assign(:item, item) }

  describe '#fields' do
    subject { helper.fields }
    it { should be_an Array }
  end

  describe '#multiple?' do
    subject { helper.multiple?(field) }
    context 'when the field is "multiple"' do
      let(:field) { :title }
      it { should be true }
    end
    context 'when the field is "single"' do
      let(:field) { :identifier }
      it { should be false }
    end
  end

  describe '#format_field_index' do
    let(:field) { [] }
    let(:index) { nil }
    subject { helper.format_field_index(field, index) }
    context "when index is nil and hence called by the last element" do
      context "when field array is blank" do
        it { should be_nil }
      end
      context "when field array contains a single value" do
        let(:field) { ["Value1"] }
        it { should be 1 }
      end
      context "when field array contains multiple values" do
        let(:field) { ["Value1","Value2"] }
        it { should be 2 }
      end
    end
    context "when index is not nil and hence not the last element" do
      let(:index) { 2 }
      context "when field array is blank" do
        it { should be_nil }
      end
      context "when field array contains values" do
        let(:field) { ["Value1","Value2","Value3"] }
        it { should be 2 }
      end
    end
  end

  describe '#field_id' do
    subject { helper.field_id(:title, 0) }
    it { should eq 'nyucore_title' }
  end
end
