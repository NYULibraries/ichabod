require 'spec_helper'
describe Beard do
  let(:prefix) { 'beard' }
  subject(:beard) { Beard.new }
  it { should be_a Beard }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:prefix) { should eq prefix }
  its(:editors) { should eq ['admin_group'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set] }
  
  describe '.prefix' do
    subject { Beard.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { Beard.source_reader }
    it 'should be a DLTS reader'
    it { should eq Ichabod::ResourceSet::SourceReaders::BeardReader }
  end
  describe '.editors' do
    subject { Beard.editors }
    it { should eq [:admin_group] }
  end
  describe '.before_loads' do
    subject { Beard.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set] }
  end
end
