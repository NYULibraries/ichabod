require 'spec_helper'
describe FacultyDigitalArchive do
  let(:prefix) { 'sdr' }
  let(:filename) { './spec/fixtures/sample_fda.xml' }
  subject { FacultyDigitalArchive.new(filename) }
  it { should be_a FacultyDigitalArchive }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:filename) { should eq filename }
  its(:editors) { should eq ['admin_group', 'fda_cataloger'] }
  its(:before_creates) { should eq [:add_edit_groups, :add_http_identifier_as_available_and_citation] }
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
    it { should eq [:add_edit_groups, :add_http_identifier_as_available_and_citation] }
  end
end
