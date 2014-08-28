require 'spec_helper'
describe NyucorePresenter do
  let(:field) { :title }
  let(:values) { attributes_for(:nyucore)[:title] }
  let(:value) { values.first }
  let(:nyucore) { build(:nyucore) }
  subject(:presenter) { NyucorePresenter.new(nyucore) }
  it { should be_a NyucorePresenter }
  describe '#nyucore' do
    subject { presenter.nyucore }
    it { should eq nyucore }
  end
  describe '#values' do
    let(:field) { 'title' }
    subject { presenter.values(field) }
    it { should eq values }
  end
  describe '#source?' do
    subject { presenter.source?(field, value) }
    it { should be false }
    context 'when the value is nil' do
      let(:value) { nil }
      it { should be false }
    end
    context "when it's source metadata" do
      let(:value) { 'source' }
      before { nyucore.source_metadata.send("#{field}=", value) }
      it { should be true }
    end
  end
  describe '#editable?' do
    subject { presenter.editable?(field, value) }
    it { should be true }
    context "when it's source metadata" do
      let(:value) { 'source' }
      before { nyucore.source_metadata.send("#{field}=", value) }
      it { should be false }
    end
  end
  describe '#multiple?' do
    subject { presenter.multiple?(field) }
    it { should be true }
    context 'when the field is "single"' do
      let(:field) { :identifier }
      it { should be false }
    end
  end
  context 'when initialized with a nyucore argument that is not an Nyucore' do
    let(:nyucore) { :invalid }
    it 'should raise an ArgumentError' do
      expect { subject }.to raise_error ArgumentError
    end
  end
end
