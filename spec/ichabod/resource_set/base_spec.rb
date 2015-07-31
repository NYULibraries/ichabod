require 'spec_helper'
module Ichabod
  module ResourceSet
    describe Base do
      let(:before_loads) { [:method1, :method2] }
      let!(:original_before_loads) { Base.before_loads - before_loads }
      let(:original_restrictions) { nil }
      let(:set_restrictions) { [:nyu_only] }
      let(:editors) { [:editor1, :editor2] }
      let(:original_editors) { Base.editors - editors }
      let(:prefix) { 'mock' }

      describe '.source_reader=' do
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

      subject(:base) { Base.new }
      it { should be_a Base }
      describe '#each' do
        subject { base.each }
        it { should be_an Enumerator }
      end

      describe '#read_from_source' do
        before { Base.source_reader = ResourceSetMocks::MockSourceReader }
        let(:base) { Base.new }
        subject { base.read_from_source }
        it 'should assign the @resources instance variable' do
          expect(base.instance_variable_get(:@resources)).to be_nil
          subject
          expect(base.instance_variable_get(:@resources)).not_to be_nil
        end
        context 'when there is no source reader configured' do
          before { Base.instance_variable_set(:@source_reader, nil) }
          it 'should raise a RuntimeError' do
            expect { subject }.to raise_error RuntimeError
          end
        end
      end

      describe '#get_records_by_prefix' do
        before { Base.prefix= prefix  }
        subject { base.get_records_by_prefix }
        it 'should assign the @resources instance variable' do
          expect(base.instance_variable_get(:@resources)).to be_nil
          subject
          expect(base.instance_variable_get(:@resources)).not_to be_nil
        end
        context 'when there is no prefix configured' do
          before { Base.prefix = nil  }
          it 'should raise a RuntimeError' do
            expect { subject }.to raise_error RuntimeError
          end
        end
      end

      describe '#load' do
        before { Base.source_reader = ResourceSetMocks::MockSourceReader }
        subject { base.load }
        it { should be_an Array }
        it { should_not be_empty }
        its(:size) { should eq 5 }
        it 'should return an array of created Nyucores' do
          subject.each do |nyucore|
            expect(nyucore).to be_an Nyucore
            expect(nyucore).to be_persisted
            expect(nyucore).not_to be_new
            expect(nyucore.resource_set).to eq 'base'
          end
        end
        context 'when there are no editors' do
          let!(:editor) { Base.set_restriction(*original_editors) }
          #before { base.instance_variable_set(:@editors, [original_editors])}
          it 'should return an array of Nyucores with no edit groups' do
            subject.each do |nyucore|
              expect(nyucore.edit_groups).to eq original_editors.map(&:to_s)
            end
          end
        end
      
        context 'when there are no restrictions' do
          let!(:restrictions) { Base.set_restriction(*original_restrictions) }
          it 'should return an array of Nyucores with no restrictions' do
            subject.each do |nyucore|
              expect(nyucore.restrictions).to be_nil
            end
          end
        end

        context 'when there are editors', vcr: {cassette_name: 'resource sets/load resource set with editors'} do
          let!(:editor) { Base.editor(*editors) }
          let!(:all) { original_editors + editors }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 5 }
          it 'should return an array of Nyucores with the specified edit groups' do
            subject.each do |nyucore|
              expect(nyucore.edit_groups).to eq all.map(&:to_s)
            end
          end
        end
        context 'when there are restrictions', vcr: {cassette_name: 'resource sets/load resource set with restrictions'} do
          let!(:restrictions) { Base.set_restriction(*set_restrictions) }
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 5 }
          it 'should return an array of Nyucores with the specified value' do
            subject.each do |nyucore|
              expect(nyucore.restrictions).to eq "NYU Only"
            end
          end
        end
      end

      describe '#delete' do
        before { Base.source_reader = ResourceSetMocks::MockSourceReader }
        before { Base.prefix = prefix }
        before { base.load }
        subject { base.delete }
        it 'should return an array of deleted Nyucores' do
          subject.each do |nyucore|
            expect(nyucore).to be_an Nyucore
            pending('Waiting for ActiveFedora 7.0 to check destruction status')
            expect(nyucore).to be_destroyed
          end
        end
        context 'when there is no prefix configured' do
          before { Base.prefix = nil }
          before { base.instance_variable_set(:@resources, nil) }
          it 'should raise a RuntimeError' do
            expect { subject }.to raise_error RuntimeError
          end
        end
      end
    end
  end
end
