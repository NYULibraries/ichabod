require 'spec_helper'
describe Masses do
  let(:prefix) { 'masses' }
  let(:endpoint_url) { 'http://dlib.nyu.edu/themasses' }
  let(:start) { 'start' }
  let(:rows) { 'rows' }
  let(:collection_code) { 'masses' }
  let(:args) { [endpoint_url, start, rows].compact }
  subject(:masses) { Masses.new(*args) }
  it { should be_a Masses }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:prefix) { should eq prefix }
  its(:endpoint_url) { should eq endpoint_url }
  its(:start) { should eq start }
  its(:rows) { should eq rows }
  its(:collection_code) { should eq collection_code }
  its(:editors) { should eq ['admin_group'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set] }
  describe '.prefix' do
    subject { Masses.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { Masses.source_reader }
    it 'should be a DLTS reader'
    it { should eq Ichabod::ResourceSet::SourceReaders::MassesReader }
  end
  describe '.editors' do
    subject { Masses.editors }
    it { should eq [:admin_group] }
  end
  describe '.before_loads' do
    subject { Masses.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set] }
  end
end