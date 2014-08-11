require 'spec_helper'
describe SpatialDataRepository do
  let(:file) { 'file' }
  subject(:spatial_data_repository) { SpatialDataRepository.new(file: file) }
  describe '.prefix' do
    subject { SpatialDataRepository.prefix }
    it { should eq 'sdr' }
  end
  describe '.source_reader_class' do
    subject { SpatialDataRepository.source_reader_class }
    it { should eq Ichabod::ResourceSet::SourceReaders::OaiDcFileReader }
  end
end
