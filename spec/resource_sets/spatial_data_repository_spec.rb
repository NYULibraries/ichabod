require 'spec_helper'
describe SpatialDataRepository do
  let(:prefix) { 'sdr' }
  let(:filename) { './spec/fixtures/sample_sdr.xml' }
  subject { SpatialDataRepository.new(filename) }
  it { should be_a SpatialDataRepository }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:filename) { should eq filename }
  its(:editors) { should eq ['admin_group', 'gis_cataloger'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set, :add_additional_info_link, :add_access_restrict] }
  describe '.prefix' do
    subject { SpatialDataRepository.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { SpatialDataRepository.source_reader }
    it { should eq Ichabod::ResourceSet::SourceReaders::OaiDcFileReader }
  end
  describe '.editors' do
    subject { SpatialDataRepository.editors }
    it { should eq [:admin_group, :gis_cataloger] }
  end
  describe '.before_loads' do
    subject { SpatialDataRepository.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set, :add_additional_info_link, :add_access_restrict] }
  end
end
