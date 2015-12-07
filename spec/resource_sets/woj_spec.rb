require 'spec_helper'
describe Woj do
  let(:prefix) { 'woj' }
  let(:endpoint_url) { 'http://www.example.com' }
  #let(:query) { '?f%5Bcollection_sim%5D%5B%5D=David+Wojnarowicz+Papers&f%5Bdao_sim%5D%5B%5D=Online+Access&f%5Bformat_sim%5D%5B%5D=Archival+Object' }
  let(:collection_code) { 'woj' }
  let(:args) { endpoint_url }
  subject { Woj.new(*args) }
  it { should be_a Woj }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:prefix) { should eq prefix }
  its(:endpoint_url) { should eq endpoint_url }
  its(:query) { should eq '?f%5Bcollection_sim%5D%5B%5D=David+Wojnarowicz+Papers&f%5Bdao_sim%5D%5B%5D=Online+Access&f%5Bformat_sim%5D%5B%5D=Archival+Object' }
  its(:editors) { should eq ['admin_group'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set] }
  describe '.prefix' do
    subject { Woj.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { Woj.source_reader }
    it 'should be an FAB reader'
    it { should eq Ichabod::ResourceSet::SourceReaders::FabReader }
  end
  describe '.editors' do
    subject { Woj.editors }
    it { should eq [:admin_group] }
  end
  describe '.before_loads' do
    subject { Woj.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set] }
  end
  
end
