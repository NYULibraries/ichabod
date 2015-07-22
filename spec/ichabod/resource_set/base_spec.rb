require 'spec_helper'
module Ichabod
  module ResourceSet
    describe Base do
      let(:before_loads) { [:method1, :method2] }
      let!(:original_before_loads) { Base.before_loads - before_loads }
      let(:set_restrictions) { [:nyu_only] }
      let(:editors) { [:editor1, :editor2] }
      let(:original_editors) { Base.editors - editors }
      let(:prefix) { 'mock' }
=begin
      describe '.prefix=' do
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
        subject { Base.editor(*editors) }
        it 'should not raise an ArgumentError' do
          expect { subject }.not_to raise_error
        end
        it 'should set the editors attribute on the class' do
          subject
          expect(Base.editors).to eq (original_editors + editors)
        end
      end

      describe '.set_restriction' do
        subject { Base.set_restriction(*set_restrictions) }
        it 'should not raise an ArgumentError' do
          expect { subject }.not_to raise_error
        end
        it 'should set the set_restrictions attribute on the class' do
          subject
          expect(Base.set_restrictions).to eq set_restrictions
        end
      end

      describe '.before_load' do
        subject { Base.before_load(*before_loads) }
        it 'should not raise an ArgumentError' do
          expect { subject }.not_to raise_error
        end
        it 'should set the before_loads attribute on the class' do
          subject
          expect(Base.before_loads).to eq (original_before_loads + before_loads)
        end
      end

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
=end
       #why are we testing the same functionality again??
      subject(:base) { Base.new }
      it { should be_a Base }
      describe '#each' do
        subject { base.each }
        it { should be_an Enumerator }
      end
      describe '#prefix' do
        subject { base.prefix }
        let(:p) { Base.prefix = nil }
        context 'when not configured with a prefix' do
          it { should eq p } 
        end
        context 'when configured with a prefix' do
          let(:p) { Base.prefix = prefix }
          it { should eq p }
        end
      end

      describe '#editors' do
        subject { base.editors }
        context 'when not configured with editors' do
          let!(:orig_editor) { Base.editor(*original_editors) }
          it { should be_an Array }
          it { should eq orig_editor.map(&:to_s) }
        end
        context 'when configured with editors' do
          let!(:all) { original_editors + editors }
          let!(:b_editors) { Base.editor(*editors) }
          it { should be_an Array }
          it { should eq all.map(&:to_s) }
        end
      end

      describe '#set_restrictions' do
        subject { base.set_restrictions }
        context 'when not configured with set_restrictions' do
          let!(:no_set_restrictions) { [] }
          let!(:no_restrictions) { Base.set_restriction(*no_set_restrictions) }
          it { should be_a String }
          it { should be_empty }
        end
      end
=begin
        context 'when configured with a value other than what is allowed for set_restrictions' do
          before { Base.set_restriction(*invalid_set_restrictions) }
          after { Base.instance_variable_set(:@set_restrictions, original_set_restrictions)}
          it { should be_a String }
          it { should_not include all_restrictions.map(&:to_s).join("")  }
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
         context 'when there are no restrictions' do
          before { base.delete }
          before { Base.instance_variable_set(:@set_restrictions, original_set_restrictions)}
          it 'should return an array of Nyucores with no restrictions' do
            subject.each do |nyucore|
              expect(nyucore.restrictions).to be_nil
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
        context 'when there are restrictions', vcr: {cassette_name: 'resource sets/load resource set with restrictions'} do
          before { Base.set_restriction(*set_restrictions) }
          after { Base.instance_variable_set(:@set_restrictions, original_set_restrictions)}
          it { should be_an Array }
          it { should_not be_empty }
          its(:size) { should eq 5 }
          it 'should return an array of Nyucores with the specified value' do
            subject.each do |nyucore|
              expect(nyucore.restrictions).to eq "NYU Only"
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
=end
  end
  end
end
