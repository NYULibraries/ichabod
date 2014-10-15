require 'spec_helper'
describe Voice do
  let(:prefix) { 'beard' }
  let(:endpoint_url) { 'https://Voices.of.food' }
  let(:collection_code) { 'beard' }
  let(:args) { endpoint_url }
  subject(:voice) { Voice.new(*args) }
  it { should be_a Voice }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:prefix) { should eq prefix }
  its(:endpoint_url) { should eq endpoint_url }
  its(:collection_code) { should eq collection_code }
  its(:editors) { should eq ['admin_group'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set] }
  
  describe '.prefix' do
    subject { Voice.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { Voice.source_reader }
    it 'should be a DLTS reader'
    it { should eq Ichabod::ResourceSet::SourceReaders::VoiceReader }
  end
  describe '.editors' do
    subject { Voice.editors }
    it { should eq [:admin_group] }
  end
  describe '.before_loads' do
    subject { Voice.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set] }
  end
end
