require 'spec_helper'
describe IndianOceanData do
  let(:prefix) { 'io' }
  let(:file_path) { 'ingest/test_io.csv' }
  let(:args) { [file_path].compact }
  subject(:indian_ocean_data) { IndianOceanData.new(*args) }
  it { should be_a IndianOceanData }
  it { should be_a Ichabod::ResourceSet::Base }
  its(:file_path) { should eq file_path }
  its(:editors) { should eq ['admin_group', 'io_cataloger'] }
  its(:before_loads) { should eq [:add_edit_groups, :add_resource_set, :set_available_or_citation, :set_title_for_untitled ] }
  describe '.prefix' do
    subject { IndianOceanData.prefix }
    it { should eq prefix }
  end
  describe '.source_reader' do
    subject { IndianOceanData.source_reader }
    it { should eq Ichabod::ResourceSet::SourceReaders::CsvFileReader }
  end
  describe '.editors' do
    subject { IndianOceanData.editors }
    it { should eq [:admin_group, :io_cataloger] }
  end
  describe '.before_loads' do
    subject { IndianOceanData.before_loads }
    it { should eq [:add_edit_groups, :add_resource_set, :set_available_or_citation, :set_title_for_untitled ] }
  end
  describe '#load', vcr: {cassette_name: 'resource sets/indian_ocean data_load'} do
    subject(:load) { indian_ocean_data.load }
    it { should be_an Array }
    it { should_not be_empty }
    its(:size) { should eq 8 }
    describe 'the first record' do
      subject { load.first }
      context 'when test records were loaded from csv file' do
        its(:identifier) { should eql 'http://hdl.handle.net/2333.1/djh9w3n0' }
        its(:title) { should eq ['VII Battaglione Eritreo'] }
        its(:subject) { should eql ['Turco-Italian War, 1911-1912','Italian military|Libya|Askari (Eritrean)','Libya'] }
        its(:subject_spatial) { should eql ['Libya'] }
        its(:language) { should eql ["Italian"] }
        its(:genre) { should eql ['Postcards'] }
        its(:type) { should eql ['still image'] }
        its(:description) { should eql ['Commemorates an Askari (Eritrian) battalion in the Italian army. Includes a list of major engagements and a listing of Italian officers.' ] }
      end
    end
  end
end
