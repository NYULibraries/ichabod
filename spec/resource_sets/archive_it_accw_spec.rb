require 'spec_helper'
describe ArchiveItAccw do
  let(:prefix) { 'ai-accw' }
  let(:endpoint_url) { 'http://www.example.com' }
  let(:path) { '/a/b/c' }
  let(:collection_code) { 'ai-accw' }
  let(:args) { [endpoint_url, path].compact }
  subject { ArchiveItAccw.new(*args) }
  it { should be_a ArchiveItAccw }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:prefix) { should eq prefix }
  its(:endpoint_url) { should eq endpoint_url }
  its(:path) { should eq path }
  its(:editors) { should eq ['admin_group', 'afc_group'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set] }
  describe '.prefix' do
    subject { ArchiveItAccw.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { ArchiveItAccw.source_reader }
    it 'should be an ArchiveIt reader' # wait for more ArchiveIt collections
    it { should eq Ichabod::ResourceSet::SourceReaders::ArchiveItAccwReader }
  end
  describe '.editors' do
    subject { ArchiveItAccw.editors }
    it { should eq [:admin_group, :afc_group] }
  end
  describe '.before_loads' do
    subject { ArchiveItAccw.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set] }
  end
  context 'when no path is provided' do
    let(:args) { [endpoint_url].compact }
    subject { ArchiveItAccw.new(*args) }
    its(:path) { should eq '/collections/4049.json' }
  end
end
