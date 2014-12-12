require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe MassesReader do
        let(:endpoint_url) { 'http://dlib.nyu.edu/themasses/books.json' }
        let(:start) { 0 }
        let(:rows) { 5 }
        let(:collection_code) { 'masses' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:endpoint_url) { endpoint_url }
          allow(resource_set).to receive(:collection_code) { collection_code }
          allow(resource_set).to receive(:start) { start }
          allow(resource_set).to receive(:rows) { rows }
        end
        subject(:reader) { MassesReader.new(resource_set) }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read' do
          subject(:read) { reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          describe 'the first record' do
            subject { read.first }
            its(:prefix) { should eq resource_set.prefix }
            its(:identifier) { should eq 'masses001' }
            its(:available) { should eq 'http://hdl.handle.net/2333.1/7m0cfzv2' }
          end
        end
      end
    end
  end
end
