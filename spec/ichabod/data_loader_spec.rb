require 'spec_helper'
module Ichabod
  describe DataLoader do
    let(:filename) { './spec/fixtures/sample_sdr.xml' }
    let(:source) { 'sdr' }
    let(:id) {  'sdr:DSS-NYCDCP_DCPLION_10cav-DSS-Lion_GJK' }
    subject(:data_loader) { DataLoader.new(filename, source) }
    it "should instantiate properly" do
      expect(data_loader.instance_variable_get(:@prefix)).to eql(source)
      expect(data_loader.instance_variable_get(:@cores)).to eql([])
    end

    describe "#load", vcr: { cassette_name: "sdr data loader" } do
      subject { data_loader.load }
      it "should create Nyucore object from file" do
        subject
        expect(data_loader.instance_variable_get(:@prefix)).to eql(source)
        expect(data_loader.instance_variable_get(:@cores)).to have(1).items
        expect(data_loader.instance_variable_get(:@cores)[0]).to be_instance_of(Nyucore)
        expect(data_loader.instance_variable_get(:@cores)[0].title).to eql('LION')
        expect(data_loader.instance_variable_get(:@cores)[0].pid).to eql(id)
        expect(data_loader.instance_variable_get(:@cores)[0].publisher).to eql('New York City Dept. of City Planning')
      end
    end
    subject { data_loader }
    #its("core") { should exist }
    its("cores") { should be_instance_of(Array) }
    describe "#delete", vcr: { cassette_name: "sdr delete" } do
      subject { data_loader.delete }
      it "should delete an existing nyucore record" do
        subject
      # Not at all sure how to test this...
      #  expect { delete :destroy, id: Nyucore.first }.to change(Nyucore, :count).by(-1)
      end
      #...
    end
  end
end