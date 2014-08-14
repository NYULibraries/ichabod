require 'spec_helper'
module Ichabod
  module ResourceSet
    describe OptionsInterpreter do
      let(:valid_candidate) { "{filename: 'filename'}" }
      let(:invalid_candidate) { 'p "I just destroyed your system"' }
      let(:candidate) { valid_candidate }
      subject(:options_interpreter) { OptionsInterpreter.new(candidate) }
      it { should be_an OptionsInterpreter }
      its(:candidate) { should eq candidate }
      describe '#valid?' do
        subject { options_interpreter.valid? }
        context 'the candidate is valid' do
          it { should be true}
        end
        context 'the candidate is invalid' do
        let(:candidate) { invalid_candidate }
        it { should be false}
        end
      end
      describe '#interpret' do
        subject { options_interpreter.interpret }
        context 'the candidate is valid' do
          it { should be_a Hash }
          it { should_not be_empty }
          its(:keys) { should eq [:filename] }
          its(:values) { should eq ['filename'] }
        end
        context 'the candidate is invalid' do
          let(:candidate) { invalid_candidate }
          it { should be_a Hash }
          it { should be_empty }
        end
      end
      context 'when initialized with a candidate that is not a string' do
        let(:candidate) { Object.new }
        it 'should raise an ArgumentError' do
          expect { subject }.to raise_error ArgumentError
        end
      end
    end
  end
end
