require 'spec_helper'
describe SpatialDataRepository do
  let(:prefix) { 'sdr' }
  let(:repo_url) { 'https://gis.spatial.repo' }
  let(:token) { 'token' }
  let(:collection_code) { 'sdr' }
  let(:args) { [repo_url, token].compact }
  subject(:spatial_data_repository) { SpatialDataRepository.new(*args) }
  it { should be_a SpatialDataRepository }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:editors) { should eq ['admin_group', 'gis_cataloger'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set] }

  describe '.prefix' do
    subject { SpatialDataRepository.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { SpatialDataRepository.source_reader }
    it { should eq Ichabod::ResourceSet::SourceReaders::GitGeoBlacklightReader }
  end
  describe '.editors' do
    subject { SpatialDataRepository.editors }
    it { should eq [:admin_group, :gis_cataloger] }
  end
  describe '.before_loads' do
    subject { SpatialDataRepository.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set] }
  end
end
