require 'spec_helper'
module Ichabod
  describe DataLoader do
    let(:filename) { './spec/fixtures/sample_sdr.xml' }
    let(:source) { 'sdr' }
    let(:id) { 'sdr:DSS-NYCDCP_MONKEY_LION-DSS-Lion_Monkey' }
    let(:data_loader) { DataLoader.new(filename, source) }
    it "should instantiate properly" do
      expect(data_loader.prefix).to eql(source)
      expect(data_loader.filename).to eql(filename)
    end

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
        its(:title) { should eql 'LION' }
        its(:publisher) { should eql 'New York City Dept. of City Planning' }
        its(:available) { should eql ['http://magellan.home.nyu.edu/datasets/zips/NYCDCP_DCPLION_10CAV-Lion_GJK.zip'] }
        its(:type) { should eql 'Geospatial Data' }
        its(:description) { should eql ['LION is a single line representation of New York City streets containing address ranges and other information.'] }
        its(:edition) { should eql ['10C'] }
        its(:series) { should eql ['NYCDCP_DCPLION_10CAV'] }
        its(:version) { should eql ['DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK'] }
        its(:addinfolink) { should eql ['http://nyu.libguides.com/content.php?pid=169769&sid=1489817']}
        its(:addinfotext) { should eql ['GIS Dataset Instructions']}
        its(:edit_groups) { should eql ['gis_cataloger'] }

      end

      context "when source is FDA", vcr: { cassette_name: "fda data load" } do
        let(:filename) { './spec/fixtures/sample_fda.xml' }
        let(:source) { 'fda' }
        let(:id) { 'fda:hdl-handle-net-2451-14097' }

        its(:pid) { should eql id }
        its(:identifier) { should eql 'http://hdl.handle.net/2451/14097' }
        its(:title) { should eql 'FDA Title' }
        its(:publisher) { should eql 'Stern' }
        its(:type) { should eql 'Working Paper' }
        its(:format) { should eql ['application/pdf'] }
        its(:language) { should eql ['English'] }
        its(:relation) { should eql ['CeDER-05-01'] }
      end
    end

    describe "#delete" do
      context "when source is SDR", vcr: { cassette_name: "sdr data delete" } do
        before(:each) {
          data_loader.load
          expect(Nyucore.find(pid: id).first).to be_instance_of Nyucore
        }

        it "should delete an existing nyucore record" do
          data_loader.delete
          expect(Nyucore.find(pid: id).first).to be_nil
        end
      end

      context "when source is FDA", vcr: { cassette_name: "fda data delete" } do
        let(:filename) { './spec/fixtures/sample_fda.xml' }
        let(:source) { 'fda' }
        let(:id) { 'fda:hdl-handle-net-2451-14097' }

        before(:each) {
          data_loader.load
          expect(Nyucore.find(pid: id).first).to be_instance_of Nyucore
        }

        it "should delete an existing nyucore record" do
          data_loader.delete
          expect(Nyucore.find(pid: id).first).to be_nil
        end
      end
    end

    describe "#field_stats" do
      subject { data_loader.field_stats }

      it "should return number of records" do
        expect(subject).to eql 1
      end
    end
  end
end
