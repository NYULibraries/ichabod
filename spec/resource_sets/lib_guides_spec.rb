require 'spec_helper'
describe LibGuides do
  let(:prefix) { 'libguides' }
  let(:filename) { './spec/fixtures/sample_libguides.xml' }
  subject { LibGuides.new(filename) }
  it { should be_a LibGuides }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:prefix) { should eq prefix }
  its(:filename) { should eq filename }
  its(:editors) { should eq ['admin_group', 'libguides_cataloger'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set] }
  describe '.prefix' do
    subject { LibGuides.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { LibGuides.source_reader }
    it { should eq Ichabod::ResourceSet::SourceReaders::LibGuidesXmlFileReader }
  end
  describe '.editors' do
    subject { LibGuides.editors }
    it { should eq [:admin_group, :libguides_cataloger] }
  end
  describe '.before_loads' do
    subject { LibGuides.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set] }
  end
end
