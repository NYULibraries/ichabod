require 'spec_helper'
describe TheLiberator do
  let(:prefix) { 'theliberator' }
  let(:endpoint_url) { 'discovery.dlib.nyu.edu:8080/solr3_discovery/viewer/select' }
  let(:collection_code) { 'theliberator' }
  let(:rows) { '77' }
  let(:start) { '0' }
  let(:args) { [endpoint_url].compact }
  subject(:the_liberator) { TheLiberator.new(*args) }
  it { should be_a TheLiberator }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:prefix) { should eq prefix }
  its(:endpoint_url) { should eq endpoint_url }
  its(:collection_code) { should eq collection_code }
  its(:rows) { should eq rows }
  its(:start) { should eq start}
  its(:editors) { should eq ['admin_group'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set] }
  describe '.prefix' do
    subject { TheLiberator.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { TheLiberator.source_reader }
    it { should eq Ichabod::ResourceSet::SourceReaders::TamimentJournalReader }
  end
  describe '.editors' do
    subject { TheLiberator.editors }
    it { should eq [:admin_group] }
  end
  describe '.before_loads' do
    subject { TheLiberator.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set] }
  end
end
