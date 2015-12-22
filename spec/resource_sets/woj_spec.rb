require 'spec_helper'
describe Woj do
  let(:prefix) { 'woj' }
  let(:page) { nil }
  let(:collection_code) { 'woj' }
  let(:d_params) { {"f[collection_sim][]" => 'David Wojnarowicz Papers', "f[dao_sim][]" => 'Online Access',"f[format_sim][]"     => 'Archival Object'} }
  let(:args) { nil }
  subject { Woj.new(*args) }
  it { should be_a Woj }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:prefix) { should eq prefix }
  its(:page) { should eq nil }
  its(:data_params) { should eq d_params }
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
