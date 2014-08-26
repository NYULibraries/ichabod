require 'spec_helper'
describe FacultyDigitalArchive do
  let(:prefix) { 'fda' }
  let(:filename) { './spec/fixtures/sample_fda.xml' }
  subject(:faculty_digital_archive) { FacultyDigitalArchive.new(filename) }
  it { should be_a FacultyDigitalArchive }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:filename) { should eq filename }
  its(:editors) { should eq ['admin_group', 'fda_cataloger'] }
  its(:before_creates) { should eq [:add_edit_groups, :add_identifier_as_available_or_citation, :set_http_identifier] }
  describe '.prefix' do
    subject { FacultyDigitalArchive.prefix }
    it { should eq prefix }
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
    it { should eq [:add_edit_groups, :add_identifier_as_available_or_citation, :set_http_identifier] }
  end
  describe '#create', vcr: {cassette_name: 'resource sets/fda create'} do
    subject(:create) { faculty_digital_archive.create }
    it { should be_an Array }
    describe 'a Nyucore record' do
      subject { create[1] }
      context 'when the record has' do
        let(:index) { 1 }
        its(:pid) { should eq '' }
        its(:identifier) { should eq '' }
        its(:title) { should include '' }
        its(:publisher) { should include '' }
        its(:available) { should include '' }
        its(:type) { should include '' }
        its(:description) { should include '' }
        its(:edition) { should include '' }
        its(:series) { should include '' }
        its(:version) { should include '' }
      end
    end
  end
end
