require 'spec_helper'
module Ichabod
  module ResourceSet
    describe Base do
      let(:before_loads) { [:method1, :method2] }
      let!(:original_before_loads) { Base.before_loads - before_loads }
      let(:editors) { [:editor1, :editor2] }
      let!(:original_editors) { Base.editors - editors }
      let(:prefix) { 'mock' }
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
      describe '.editor' do
        after { Base.instance_variable_set(:@editors, original_editors)}
        subject { Base.editor(*editors) }
        it 'should not raise an ArgumentError' do
          expect { subject }.not_to raise_error
        end
        it 'should set the editors attribute on the class' do
          subject
          expect(Base.editors).to eq editors.unshift(*original_editors)
        end
      end
      describe '.before_load' do
        after do
          Base.instance_variable_set(:@before_loads, original_before_loads)
        end
        subject { Base.before_load(*before_loads) }
        it 'should not raise an ArgumentError' do
          expect { subject }.not_to raise_error
        end
        it 'should set the before_loads attribute on the class' do
          subject
          expect(Base.before_loads).to eq before_loads.unshift(*original_before_loads)
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
      subject(:base) { Base.new }
      it { should be_a Base }
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
      describe '#editors' do
        subject { base.editors }
        context 'when not configured with editors' do
          it { should be_an Array }
          it { should eq original_editors.map(&:to_s) }
        end
        context 'when configured with editors' do
          before { Base.editor(*editors) }
          after { Base.instance_variable_set(:@editors, original_editors)}
          it { should be_an Array }
          it { should eq editors.map(&:to_s).unshift(*original_editors.map(&:to_s)) }
        end
      end
      describe '#before_loads' do
        subject { base.before_loads }
        context 'when not configured with before loads' do
          it { should be_an Array }
          it { should eql original_before_loads }
        end
        context 'when configured with before loads' do
          before { Base.before_load(*before_loads) }
          after do
            Base.instance_variable_set(:@before_loads, original_before_loads)
          end
          it { should eq before_loads.map(&:to_sym).unshift(*original_before_loads.map(&:to_sym)) }
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
        context 'when there is no source reader configured' do
          before { Base.instance_variable_set(:@source_reader, nil) }
          it 'should raise a RuntimeError' do
            expect { subject }.to raise_error RuntimeError
          end
        end
      end
      describe '#load' do
        before { Base.source_reader = ResourceSetMocks::MockSourceReader }
        after { Base.instance_variable_set(:@source_reader, nil) }
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
          before { base.delete }
          before { Base.instance_variable_set(:@editors, original_editors)}
          it 'should return an array of Nyucores with no edit groups' do
            subject.each do |nyucore|
              expect(nyucore.edit_groups).to eq original_editors.map(&:to_s)
            end
          end
        end
        context 'when there are editors', vcr: {cassette_name: 'resource sets/load resource set with editors'} do
          before { Base.editor(*editors) }
          after { Base.instance_variable_set(:@editors, original_editors)}
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 5 }
          it 'should return an array of Nyucores with the specified edit groups' do
            subject.each do |nyucore|
              expect(nyucore.edit_groups).to eq editors.map(&:to_s).unshift(*original_editors.map(&:to_s))
            end
          end
        end
        context 'when there is no source reader configured' do
          before { Base.instance_variable_set(:@source_reader, nil) }
          it 'should raise a RuntimeError' do
            expect { subject }.to raise_error RuntimeError
          end
        end
      end
      describe '#delete' do
        before { Base.source_reader = ResourceSetMocks::MockSourceReader }
        before { base.load }
        after { Base.instance_variable_set(:@source_reader, nil) }
        subject { base.delete }
        it 'should return an array of deleted Nyucores' do
          subject.each do |nyucore|
            expect(nyucore).to be_an Nyucore
            pending('Waiting for ActiveFedora 7.0 to check destruction status')
            expect(nyucore).to be_destroyed
          end
        end
        context 'when there is no source reader configured' do
          before { Base.instance_variable_set(:@source_reader, nil) }
          before { base.instance_variable_set(:@resources, nil) }
          it 'should raise a RuntimeError' do
            expect { subject }.to raise_error RuntimeError
          end
        end
      end
    end
  end
end
