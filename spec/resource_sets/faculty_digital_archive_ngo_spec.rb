require 'spec_helper'
describe FacultyDigitalArchiveNgo do
  let(:prefix) { 'fda' }
  let(:endpoint_url) { 'http://archive.nyu.edu/request' }
  let(:set_handle) { 'hdl_2451_33605' }
  let(:args) { [endpoint_url, set_handle].compact }
  subject(:faculty_digital_archive_ngo) { FacultyDigitalArchiveNgo.new(*args) }
  it { should be_a FacultyDigitalArchiveNgo }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:endpoint_url) { should eq endpoint_url }
  its(:set_handle) { should eq set_handle }
  its(:editors) { should eq ['admin_group', 'fda_cataloger'] }
  its(:before_creates) { should eq [:add_edit_groups,:set_available_or_citation, :set_type] }
  describe '.prefix' do
    subject { FacultyDigitalArchiveNgo.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { FacultyDigitalArchiveNgo.source_reader }
    it { should eq Ichabod::ResourceSet::SourceReaders::OaiDcHttpReader }
  end
  describe '.editors' do
    subject { FacultyDigitalArchiveNgo.editors }
    it { should eq [:admin_group, :fda_cataloger] }
  end
  describe '.before_creates' do
    subject { FacultyDigitalArchiveNgo.before_creates }
    it { should eq [:add_edit_groups, :set_available_or_citation, :set_type,] }
  end
end
