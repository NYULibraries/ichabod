require 'spec_helper'
describe FacultyDigitalArchive do
  let(:filename) { './spec/fixtures/sample_fda.xml' }
  subject(:faculty_digital_archive) { FacultyDigitalArchive.new(filename: filename) }
  describe '.prefix' do
    subject { FacultyDigitalArchive.prefix }
    it { should eq 'fda' }
  end
  describe '.source_reader' do
    subject { FacultyDigitalArchive.source_reader }
    it { should eq Ichabod::ResourceSet::SourceReaders::OaiDcFileReader }
  end
  describe '.editors' do
    subject { FacultyDigitalArchive.editors }
    it { should eq [:admin_group, :fda_cataloger] }
  end
  describe '.before_creates' do
    subject { FacultyDigitalArchive.before_creates }
    it { should eq [:add_edit_groups, :add_http_identifier_as_available] }
  end
  describe '#editors' do
    subject { faculty_digital_archive.editors }
    it { should eq ['admin_group', 'fda_cataloger'] }
  end
  describe '#before_creates' do
    subject { faculty_digital_archive.before_creates }
    it { should eq [:add_edit_groups, :add_http_identifier_as_available] }
  end
end
