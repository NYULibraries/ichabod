module Ichabod
  describe DataLoader do
    let(:filename) { './spec/fixtures/sample_sdr.xml' }
    let(:source) { 'sdr' }
    let(:id) {  'sdr:DSS-NYCDCP_DCPLION_10cav-DSS-Lion_GJK' }
    subject(:data_loader) { DataLoader.new(filename, source) }
 
    describe "#load", vcr: { cassette_name: "sdr data loader" } do
      subject { data_loader.load }
      it "should create Nyucore object from file" do
        subject
        #it "should have an id equal to sdr:DSS-NYCDCP_DCPLION_10cav-DSS-Lion_GJK" do
        #  expect(assigns(:item).identifier).to eql(:id)
        #end
        # some expectations
        #...
      end
    end
 
    describe "#delete", vcr: { cassette_name: "sdr delete" } do
      subject { data_loader.delete }
      #it "should delete an existing nyucore record" do
      #  expect { delete :destroy, id: Nyucore.first }.to change(Nyucore, :count).by(-1)
      #end
      #...
    end
  end
end