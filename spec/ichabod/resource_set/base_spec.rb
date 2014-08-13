require 'spec_helper'
module Ichabod
  module ResourceSet
    describe Base do
      let(:prefix) { 'mock' }
      let(:management_group) { 'managers' }
      describe '.prefix=' do
        after { Base.prefix=(nil)}
        subject { Base.prefix=(prefix) }
        it 'should not raise an ArgumentError' do
          expect { subject }.not_to raise_error
        end
        it 'should set the prefix attribute on the class' do
          subject
          expect(Base.prefix).to eq prefix
        end
      end
      describe '.management_group=' do
        after { Base.management_group=(nil)}
        subject { Base.management_group=(management_group) }
        it 'should not raise an ArgumentError' do
          expect { subject }.not_to raise_error
        end
        it 'should set the management_group attribute on the class' do
          subject
          expect(Base.management_group).to eq management_group
        end
      end
      describe '.source_reader=' do
        after { Base.instance_variable_set(:@source_reader, nil)}
        subject { Base.source_reader=(source_reader) }
        context 'when the source_reader argument cannot be coerced into a SourceReader' do
          let(:source_reader) { 'invalid' }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error ArgumentError
          end
        end
        context 'when the source_reader argument can be coerced into a SourceReader' do
          let(:source_reader) { :oai_dc_file_reader }
          it 'should not raise an ArgumentError' do
            expect { subject }.not_to raise_error
          end
          it 'should set the source reader class attribute on the class' do
            subject
            expect(Base.source_reader).to eq SourceReaders::OaiDcFileReader
          end
        end
        context 'when the source_reader argument is a Class' do
          context 'but it is not a descendant of SourceReader' do
            let(:source_reader) { Object }
            it 'should raise an ArgumentError' do
              expect { subject }.to raise_error ArgumentError
            end
          end
          context 'and it is a descendant of SourceReader' do
            let(:source_reader) { SourceReader }
            it 'should not raise an ArgumentError' do
              expect { subject }.not_to raise_error
            end
            it 'should set the source reader class attribute on the class' do
              subject
              expect(Base.source_reader).to eq SourceReader
            end
          end
        end
      end
      let(:options) { {file: 'file'} }
      subject(:base) { Base.new(options) }
      it { should be_a Base }
      describe '#options' do
        subject { base.options }
        it { should be_a Hash }
        it { should_not be_empty }
        it { should eq options }
        context 'when initialized without options' do
          let(:base) { Base.new }
          it { should be_a Hash }
          it { should be_empty }
        end
      end
      describe '#respond_to?' do
        subject { base.respond_to?(method_name) }
        context 'when the method is not really missing' do
          let(:method_name) { :file }
          it { should be true }
        end
        context 'when the method is really missing' do
          let(:method_name) { :missing }
          it { should be false }
        end
      end
      describe '#method_missing' do
        subject { base.method_missing(method_name) }
        context 'when the method is not really missing' do
          let(:method_name) { :file }
          it { should eq 'file' }
        end
        context 'when the method is really missing' do
          let(:method_name) { :missing }
          it 'should raise a NameError' do
            expect { subject }.to raise_error NameError
          end
        end
      end
      describe '#each' do
        subject { base.each }
        it { should be_an Enumerator }
      end
      describe '#size' do
        subject { base.size }
        context 'when we have read from source' do
          before { Base.source_reader = ResourceSetMocks::MockSourceReader }
          before { base.read_from_source }
          after { Base.instance_variable_set(:@source_reader, nil) }
          it { should be > 0 }
        end
        context 'when we have read from source' do
          it { should eq 0 }
        end
      end
      describe '#prefix' do
        subject { base.prefix }
        context 'when not configured with a prefix' do
          it { should be_nil }
        end
        context 'when configured with a prefix' do
          before { Base.prefix = prefix }
          after { Base.prefix = nil}
          it { should eq prefix }
        end
      end
      describe '#management_group', half_baked: true do
        subject { base.management_group }
        context 'when not configured with a management group' do
          it { should be_nil }
        end
        context 'when configured with a management group' do
          before { Base.management_group = management_group }
          after { Base.management_group = nil }
          it { should be_a ManagementGroup }
        end
      end
      describe '#read_from_source' do
        before { Base.source_reader = ResourceSetMocks::MockSourceReader }
        after { Base.instance_variable_set(:@source_reader, nil) }
        subject { base.read_from_source }
        it 'should assign the @resources instance variable' do
          expect(base.instance_variable_get(:@resources)).to be_nil
          subject
          expect(base.instance_variable_get(:@resources)).not_to be_nil
        end
      end
      describe '#persist' do
        subject { base.persist }
        it 'should persist the Resources to Fedora as Nyucores'
        it 'should index the Nyucores in Solr'
        it 'should return an array of persisted Nyucores'
      end
      describe '.delete' do
        subject { Base.delete }
        it 'should delete the associated Nyucores from Fedora'
        it 'should delete the Nyucores from the Solr index'
        it 'should return an array of deleted Nyucores'
      end
    end
  end
end
