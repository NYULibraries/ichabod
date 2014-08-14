require 'spec_helper'
describe SpatialDataRepository do
  let(:file) { './spec/fixtures/sample_sdr.xml' }
  subject(:spatial_data_repository) { SpatialDataRepository.new(file: file) }
  describe '.prefix' do
    subject { SpatialDataRepository.prefix }
    it { should eq 'sdr' }
  end
  describe '.source_reader' do
    subject { SpatialDataRepository.source_reader }
    it { should eq Ichabod::ResourceSet::SourceReaders::OaiDcFileReader }
  end
  describe '.editors' do
    subject { SpatialDataRepository.editors }
    it { should eq [:admin_group, :gis_cataloger] }
  end
  describe '.before_creates' do
    subject { SpatialDataRepository.before_creates }
    it { should eq [:add_edit_groups, :add_additional_info_link] }
  end
  describe '#editors' do
    subject { spatial_data_repository.editors }
    it { should eq ['admin_group', 'gis_cataloger'] }
  end
  describe '#before_creates' do
    subject { spatial_data_repository.before_creates }
    it { should eq [:add_edit_groups, :add_additional_info_link] }
  end
end
