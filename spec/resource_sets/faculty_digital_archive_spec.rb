require 'spec_helper'
describe FacultyDigitalArchive do
  let(:prefix) { 'fda' }
  let(:filename) { './spec/fixtures/sample_fda.xml' }
  subject(:faculty_digital_archive) { FacultyDigitalArchive.new(filename) }
  it { should be_a FacultyDigitalArchive }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:filename) { should eq filename }
  its(:editors) { should eq ['admin_group', 'fda_cataloger'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set, :add_identifier_as_available_or_citation, :set_http_identifier] }
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
  describe '.before_loads' do
    subject { FacultyDigitalArchive.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set, :add_identifier_as_available_or_citation, :set_http_identifier] }
  end
  describe '#load', vcr: {cassette_name: 'resource sets/fda load'} do
    subject(:load) { faculty_digital_archive.load }
    it { should be_an Array }
    describe 'a Nyucore record' do
      subject { load[index] }
      context 'when the record has multiple identifiers' do
        let(:index) { 1 }
        its(:pid) { should eq 'fda:hdl-handle-net-2451-27761' }
        its(:identifier) { should eq 'http://hdl.handle.net/2451/27761' }
        its(:title) { should include 'IT Assets, Organizational Capabilities, and Firm Performance: How Resource Allocations and Organizational Differences Explain Performance Variation' }
        its(:publisher) { should include 'Organization Science' }
        its(:available) { should include 'http://hdl.handle.net/2451/27761' }
        its(:creator) { should include 'Aral, Sinan' }
        its(:type) { should include 'Article' }
        #its(:language) { should include 'en_US' }
        its(:citation) { should include 'Vol. 18, No. 5, September-October 2007, pp. 763-780' }
        its(:subject) { should include 'IT infrastructure' }
        its(:date) { should include '2008-11-10T21:37:47Z' }
        its(:format) { should include '187093 bytes' }
        its(:relation) { should include 'http://archive.nyu.edu/bitstream/2451/27761/2/CPP-12-07.pdf' }
        # its(:description) { should include '' }
      end
    end
  end
end
