require 'spec_helper'
module Ichabod
  describe DataLoader do
    let(:filename) { './spec/fixtures/sample_sdr.xml' }
    let(:source) { 'sdr' }
    let(:id) {  'sdr:DSS-NYCDCP_DCPLION_10cav-DSS-Lion_GJK' }
    subject(:data_loader) { DataLoader.new(filename, source) }
    it "should instantiate properly" do
      expect(data_loader.prefix).to eql(source)
      expect(data_loader.filename).to eql(filename)
    end

    describe "#load", vcr: { cassette_name: "sdr data loader" } do
      let(:records) { data_loader.load }
      #expect(:records).to have(1).items
      subject(:record) { records.first }
      it "should make an nyucore record from file" do
        expect(subject).to be_instance_of(Nyucore)
      end
      its(:pid) { should eql id }
      its(:identifier) { should eql 'DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK' }
      its(:title) { should eql 'LION' }
      its(:publisher) { should eql 'New York City Dept. of City Planning' }
      its(:available) { should eql ['http://magellan.home.nyu.edu/datasets/zips/NYCDCP_DCPLION_10CAV-Lion_GJK.zip'] }
      its(:type) { should eql 'Geospatial Data' }
      its(:description) { should eql ['LION is a single line representation of New York City streets containing address ranges and other information.'] }
      its(:edition) { should eql ['10C'] }
      its(:series) { should eql ['NYCDCP_DCPLION_10CAV'] }
      its(:version) { should eql ['DSS.NYCDCP_DCPLION_10cav\DSS.Lion_GJK'] }
      #expect(data_loader.instance_variable_get(:@cores)[0]).to be_instance_of(Nyucore)
      #expect(data_loader.instance_variable_get(:@cores)[0].title).to eql('LION')
      #expect(data_loader.instance_variable_get(:@cores)[0].pid).to eql(id)
      #expect(data_loader.instance_variable_get(:@cores)[0].publisher).to eql('New York City Dept. of City Planning')

    end

    describe "#delete", vcr: { cassette_name: "sdr delete" } do
      subject { data_loader.delete }
      it "should delete an existing nyucore record" do
        subject
        expect { data_loader.delete }.to change(Nyucore, :count).by(-1)
      # Not at all sure how to test this...
      #  expect { delete :destroy, id: Nyucore.first }.to change(Nyucore, :count).by(-1)
      end
      #...
    end
  end
end