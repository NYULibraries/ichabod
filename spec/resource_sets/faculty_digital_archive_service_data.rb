require 'spec_helper'
describe FacultyDigitalArchiveServiceData do
  let(:prefix) { 'fda' }
  let(:file_path) { 'ingest/2451-33611.csv' }
  let(:load_number_of_records) { 5 }
  let(:args) { [file_path, load_number_of_records].compact }
  subject(:faculty_digital_archive_service_data) { FacultyDigitalArchiveServiceData.new(*args) }
  it { should be_a FacultyDigitalArchiveServiceData }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:file_path) { should eq file_path }
  its(:load_number_of_records) { should eq load_number_of_records }
  its(:editors) { should eq ['admin_group', 'fda_cataloger'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set, :set_available_or_citation ] }
  describe '.prefix' do
    subject { FacultyDigitalArchiveServiceData.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { FacultyDigitalArchiveServiceData.source_reader }
    it { should eq Ichabod::ResourceSet::SourceReaders::CsvFileReader }
  end
  describe '.editors' do
    subject { FacultyDigitalArchiveServiceData.editors }
    it { should eq [:admin_group, :fda_cataloger] }
  end
  describe '.before_loads' do
    subject { FacultyDigitalArchiveServiceData.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set, :set_available_or_citation] }
  end
end
