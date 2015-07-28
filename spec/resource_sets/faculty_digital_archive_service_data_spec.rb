require 'spec_helper'
describe FacultyDigitalArchiveServiceData do
  let(:prefix) { 'fda' }
  let(:file_path) { 'ingest/test_data_service.csv' }
  let(:args) { [file_path].compact }
  subject(:faculty_digital_archive_service_data) { FacultyDigitalArchiveServiceData.new(*args) }
  it { should be_a FacultyDigitalArchiveServiceData }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:file_path) { should eq file_path }
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
  describe '#load', vcr: {cassette_name: 'resource sets/fda data_service_load'} do
    subject(:load) { faculty_digital_archive_service_data.load }
    it { should be_an Array }
    it { should_not be_empty }
    its(:size) { should eq 5 }
    describe 'the first record' do
      subject { load.first }
      context 'when test records were loaded from csv file' do
        its(:identifier) { should eql 'http://hdl.handle.net/2451/33978' }
        its(:title) { should eq ['Gallup GPSS and Assorted Poll Data and Questionnaires from 2001-2015'] }
        its(:subject) { should eql ['2001-2015'] }
        its(:format) { should eql ['.sav'] }
        its(:description) { should eql ['This archive contains data files in .sav format (SPSS) for Gallup Poll Social Series (GPSS) and other assorted polls that contain the question, "what is the most important issue facing our country today?" Note that these polls are not comprehensive; rather, they have been collected here simply because they contain the aforementioned question.'] }
      end
    end
  end
end
