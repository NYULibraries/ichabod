require "spec_helper"
describe NyucoresHelper do
  let(:item) { build(:nyucore) }
  before { assign(:item, item) }

  describe '#fields' do
    subject { helper.fields }
    it { should be_an Array }
  end

  describe '#values' do
    subject { helper.values(:title) }
    it { should be_an Array }
  end

  describe '#multiple?' do
    subject { helper.multiple?(:title) }
    it { should be true }
  end

  describe '#source?' do
    subject { helper.source?(:title, item.title.first) }
    it { should be false }
  end

  describe '#editable?' do
    subject { helper.editable?(:title, item.title.first) }
    it { should be true }
  end

  describe '#nyucore_presenter' do
    subject { helper.nyucore_presenter }
    it { should be_an NyucorePresenter }
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
