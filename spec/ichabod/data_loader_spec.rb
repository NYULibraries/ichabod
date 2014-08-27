require 'spec_helper'
module Ichabod
  describe DataLoader do
    let(:name) { 'spatial_data_repository' }
    let(:args) { [filename] }
    let(:filename) { './spec/fixtures/sample_sdr.xml' }
    let(:id) { 'sdr:DSS-NYCDCP_MONKEY_LION-DSS-Lion_Monkey' }
    subject(:data_loader) { DataLoader.new(name, *args) }
    its(:name) { should eq name }
    its(:args) { should eq args }
    describe "#load" do
      let(:records) { data_loader.load }
      subject(:record) { records.first }
      context "when source is SDR", vcr: { cassette_name: "sdr data load" } do
        it "should load an nyucore record" do
          data_loader.load
          expect(Nyucore.find(pid: id).first).to be_instance_of Nyucore
        end
        it "should be an NYUCore record" do
          expect(subject).to be_instance_of(Nyucore)
        end
        its(:pid) { should eql id }
        its(:identifier) { should eql 'DSS.NYCDCP_MONKEY_LION\DSS.Lion_Monkey' }
        its(:title) { should eql ['LION'] }
        its(:publisher) { should eql ['New York City Dept. of City Planning'] }
        its(:available) { should eql ['http://magellan.home.nyu.edu/datasets/zips/NYCDCP_DCPLION_10CAV-Lion_GJK.zip'] }
        its(:type) { should eql ['Geospatial Data'] }
        its(:description) { should eql ['LION is a single line representation of New York City streets containing address ranges and other information.'] }
        its(:edition) { should eql ['10C'] }
        its(:series) { should eql ['NYCDCP_DCPLION_10CAV'] }
        its(:version) { should eql ['DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK'] }
        its(:addinfolink) { should eql ['http://nyu.libguides.com/content.php?pid=169769&sid=1489817']}
        its(:addinfotext) { should eql ['GIS Dataset Instructions']}
        its(:edit_groups) { should eql ['admin_group', 'gis_cataloger'] }
      end
      context "when source is FDA", vcr: { cassette_name: "fda data load" } do
        let(:name) { 'faculty_digital_archive' }
        let(:filename) { './spec/fixtures/sample_fda.xml' }
        let(:id) { 'fda:hdl-handle-net-2451-14097' }
        its(:pid) { should eql id }
        its(:identifier) { should eql 'http://hdl.handle.net/2451/14097' }
        its(:available) { should eql ['http://hdl.handle.net/2451/14097'] }
        its(:citation) { should eql ['http://hdl.handle.net/2451/14097'] }
        its(:title) { should eql ['FDA Title'] }
        its(:publisher) { should eql ['Stern'] }
        its(:type) { should eql ['Working Paper'] }
        its(:format) { should eql ['application/pdf'] }
        its(:language) { should eql ['English'] }
        its(:relation) { should eql ['CeDER-05-01'] }
        its(:edit_groups) { should eql ['admin_group', 'fda_cataloger'] }
      end
    end
    describe "#delete" do
      before do
        data_loader.load
        data_loader.delete
      end
      context "when source is the Spatial Data Repository", vcr: { cassette_name: "sdr data delete" } do
        it "should delete an existing nyucore record" do
          expect(Nyucore.find(pid: id)).to be_blank
        end
      end
      context "when source is the Faculty Digital Archive", vcr: { cassette_name: "fda data delete" } do
        let(:name) { 'faculty_digital_archive' }
        let(:filename) { './spec/fixtures/sample_fda.xml' }
        let(:id) { 'fda:hdl-handle-net-2451-14097' }
        it "should delete an existing nyucore record" do
          expect(Nyucore.find(pid: id)).to be_blank
        end
      end
    end
    describe "#read" do
      subject { data_loader.read }
      it { should be_an Array }
      it { should_not be_empty }
    end
    context 'when initialized with a name that cannot be coerced into a Class' do
      let(:name) { 'invalid' }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
      context 'when initialized with a name that can be coerced into a Class' do
        context 'but it is not a ResourceSet' do
          let(:name) { 'hash' }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
