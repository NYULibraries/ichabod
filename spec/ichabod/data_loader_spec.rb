require 'spec_helper'
module Ichabod
  describe DataLoader do
    let(:filename) { './spec/fixtures/sample_sdr.xml' }
    let(:source) { 'sdr' }
    let(:id) {  'sdr:DSS-NYCDCP_MONKEY_LION-DSS-Lion_Monkey' }
    let(:data_loader) { DataLoader.new(filename, source) }
    it "should instantiate properly" do
      expect(data_loader.prefix).to eql(source)
      expect(data_loader.filename).to eql(filename)
    end

    describe "#load", vcr: { cassette_name: "sdr data load" } do
      it "should load an nyucore record" do
        data_loader.load
        expect(Nyucore.find(pid: id).first).to be_instance_of Nyucore
      end
      let(:records) { data_loader.load }

      subject(:record) { records.first }
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

    end

    describe "#delete", vcr: { cassette_name: "sdr data delete" } do
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
end