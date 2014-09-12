require 'spec_helper'
describe Nyucore::Metadatum do
  let(:index) { 0 }
  let(:value) { 'value' }
  let(:nyucore) do
    _nyucore = build(:nyucore, title: value)
    _nyucore.source_metadata.title = value
    _nyucore
  end
  let(:datastream) { nyucore.source_metadata }
  subject(:metadatum) { Nyucore::Metadatum.new(value, datastream) }
  it { should be_a String }
  it { should be_a Nyucore::Metadatum }
  its(:index) { should eq index }
  describe '#datastream' do
    it 'should eq "datastream" but there seems to be a bug in ActiveFedora::Datastream#== for this version'
    it 'should match the datastream' do
      expect(metadatum.datastream.dsid).to eq datastream.dsid
    end
  end
  describe '#source?' do
    subject { metadatum.source? }
    context 'when it is a source metadatum' do
      let(:datastream) { nyucore.source_metadata }
      it { should be true }
    end
    context 'when it is not a source metadatum' do
      let(:datastream) { nyucore.native_metadata }
      it { should be false }
    end
  end
  context 'when initialized with a datastream that is not an Ichabod::NyucoreDatastream' do
    let(:datastream) { 'invalid' }
    it 'should raise an ArgumentError' do
      expect { subject }.to raise_error ArgumentError
    end
  end
end
