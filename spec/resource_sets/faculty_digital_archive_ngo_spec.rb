require 'spec_helper'
describe FacultyDigitalArchiveNgo do
  let(:prefix) { 'fda' }
  let(:file_path) { 'ingest/test_ngo_fda.csv' }
  let(:args) { [file_path].compact }
  subject(:faculty_digital_archive_ngo) { FacultyDigitalArchiveNgo.new(*args) }
  it { should be_a FacultyDigitalArchiveNgo }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:file_path) { should eq file_path }
  its(:editors) { should eq ['admin_group', 'fda_cataloger'] }
  its(:header_map) { should  include( identifier: ["identifier.uri","identifier.citation"], title: ["title" ], creator: ["contributor.author" ],
                                  description: ["description" ], date: ["date.issued" ], publisher: [["publisher.place","publisher","date.issued"],[":",","]],
                                  format: ["format" ], rights: ["rights" ], subject: ["subject" ], relation: ["identifier.citation"] ) }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set, :set_available_or_citation, :set_type ] }
  describe '.prefix' do
    subject { FacultyDigitalArchiveNgo.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { FacultyDigitalArchiveNgo.source_reader }
    it { should eq Ichabod::ResourceSet::SourceReaders::CsvFileReader }
  end
  describe '.editors' do
    subject { FacultyDigitalArchiveNgo.editors }
    it { should eq [:admin_group, :fda_cataloger] }
  end
  describe '.before_loads' do
    subject { FacultyDigitalArchiveNgo.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set, :set_available_or_citation, :set_type ] }
  end
  describe '#load', vcr: {cassette_name: 'fda data_load'} do
    subject(:load) { faculty_digital_archive_ngo.load }
    it { should be_an Array }
    it { should_not be_empty }
    describe 'the first record' do
      subject { load.first }
      context 'when test records were loaded from csv file' do
        its(:pid) { should eq 'fda:hdl-handle-net-2451-33612' }
        its(:identifier) { should eq 'http://hdl.handle.net/2451/33612' }
        its(:title) { should eq ['Hijras/transgender women in India: HIV, human rights and social exclusion'] }
        its(:publisher) { should eq ['[New Delhi]:United Nations Development Programme (UNDP), India,2010-12'] }
        its(:available) { should eq ['http://hdl.handle.net/2451/33612'] }
        its(:creator) { should eql ['Chakrapani, Venkatesan','United Nations Development Programme (UNDP), India'] }
        its(:type) { should eql ['Report'] }
        its(:citation) { should eq ['http://www.undp.org/content/dam/india/docs/hijras_transgender_in_india_hiv_human_rights_and_social_exclusion.pdf'] }
        its(:subject) { should eql [ 'Social conditions', 'Social structure', 'Sexually transmitted diseases', 'AIDS', 'Gender discrimination'] }
        its(:date) { should eql ['2010-12'] }
        its(:description) { should eq ['The focus of this Transgender Issue Brief is to summarize the various issues faced by Hijras and transgender women.'] }
        its(:rights) { should eq ['NYU Libraries is providing access to these materials as a service to our scholarly community.'] }
      end
    end
  end
end
