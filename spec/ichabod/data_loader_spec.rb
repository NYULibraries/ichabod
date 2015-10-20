require 'spec_helper'
module Ichabod
  describe DataLoader do
    let(:name) { 'faculty_digital_archive' }
    let(:args) { [filename] }
    let(:filename) { './spec/fixtures/sample_fda.xml' }
    let(:id) { 'fda:hdl-handle-net-2451-14097' }
    subject(:data_loader) { DataLoader.new(name, *args) }
    its(:name) { should eq name }
    its(:args) { should eq args }
    describe "#load" do
      let(:records) { data_loader.load }
      subject(:record) { records.first }
      context "when source is FDA", vcr: { cassette_name: 'data loader/fda/load' } do
        let(:name) { 'faculty_digital_archive' }
        let(:filename) { './spec/fixtures/sample_fda.xml' }
        let(:id) { 'fda:hdl-handle-net-2451-14097' }
        its(:pid) { should eql id }
        its(:identifier) { should eql 'http://hdl.handle.net/2451/14097' }
        its(:available) { should eql ['http://hdl.handle.net/2451/14097'] }
        its(:citation) { should be_empty }
        its(:title) { should eql ['FDA Title'] }
        its(:publisher) { should eql ['Stern'] }
        its(:type) { should eql ['Working Paper'] }
        its(:format) { should eql ['application/pdf'] }
        its(:relation) { should eql ['CeDER-05-01'] }
        its(:edit_groups) { should eql ['admin_group', 'fda_cataloger'] }
      end
    end
    describe "#delete" do
      before do
        data_loader.load
        data_loader.delete
      end
      context "when source is the Faculty Digital Archive", vcr: { cassette_name: 'data loader/fda/delete' } do
        let(:name) { 'faculty_digital_archive' }
        let(:filename) { './spec/fixtures/sample_fda.xml' }
        let(:id) { 'fda:hdl-handle-net-2451-14097' }
        it "should delete an existing nyucore record" do
          expect(Nyucore.find(pid: id)).to be_empty
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
