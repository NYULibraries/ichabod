require 'spec_helper'
module Ichabod
  module ResourceSet
    describe SourceReader do
      let(:resource_set) { mock_resource_set }
      subject(:source_reader) { SourceReader.new(resource_set) }
      it { should be_a SourceReader }
      describe '#read' do
        subject { source_reader.read }
        it 'should raise a RuntimeError' do
          expect { subject }.to raise_error RuntimeError
        end
      end
      context 'when initialized without a resource_set argument that is not a ResourceSet' do
        let(:resource_set) { 'invalid' }
        it 'should raise an ArgumentError' do
          expect { subject }.to raise_error ArgumentError
        end
      end
    end
  end
end
