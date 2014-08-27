require 'spec_helper'

describe Nyucore, vcr: {cassette_name: "models/nyucore", record: :once} do

  describe Nyucore::FIELDS do
    subject { Nyucore::FIELDS }
    it { should be_a Hash }
    it { should have_key :single }
    it { should have_key :multiple }
  end

  subject(:nyucore) { build(:nyucore) }

  describe '#native_metadata' do
    subject { nyucore.native_metadata }
    it { should be_a NyucoreRdfDatastream }
  end

  describe '#source_metadata' do
    subject { nyucore.source_metadata }
    it { should be_a NyucoreRdfDatastream }
  end

  describe "#collections" do
    subject { nyucore.collections }
    it { should be_instance_of Nyucore::Collections }
  end

  # Some meta programming to test all the single-valued Nyucore attributes
  Nyucore::FIELDS[:single].each do |field|
    # Generic test for presence
    its(field) { should be_present }


    # Test the attribute writers
    describe "##{field}=" do
      let(:value) { "Native #{field}" }
      let(:nyucore) { build(:nyucore, field => nil) }
      subject { nyucore.send("#{field}=".to_sym, value) }
      it "should set the #{field} attribute" do
        expect(nyucore.send(field)).to be_blank
        subject
        expect(nyucore.send(field)).to be_present
        expect(nyucore.send(field)).to eq value
      end
      it "should set the #{field} attribute in the native_metadata datastream" do
        expect(nyucore.native_metadata.send(field)).to be_blank
        subject
        expect(nyucore.native_metadata.send(field)).to be_present
        expect(nyucore.native_metadata.send(field)).to eq [value]
      end
      context 'when the value is correctly passed in as an Array' do
        let(:value) { ['1', '2'] }
        it "should set the #{field} attribute as an Array" do
          expect(nyucore.send(field)).to be_blank
          subject
          expect(nyucore.send(field)).to be_present
          expect(nyucore.send(field)).to eq value.first
        end
      end
      context 'when the value is incorrectly passed in as a String' do
        let(:value) { '1' }
        it "should set the #{field} attribute as an Array" do
          expect(nyucore.send(field)).to be_blank
          subject
          expect(nyucore.send(field)).to be_present
          expect(nyucore.send(field)).to eq value
        end
      end
    end

    # Test the attribute readers
    describe "##{field}" do
      let(:source_value) { 'source value' }
      let(:native_value) { 'native value' }
      subject { nyucore.send(field) }
      it { should be_present }
      it { should be_a String }
      context 'when there is source metadata' do
        before { nyucore.source_metadata.send("#{field}=", source_value) }
        context 'but there is no native metadata' do
          it { should eq source_value }
        end
        context 'and there is native metadata' do
          before { nyucore.send("#{field}=", native_value) }
          it { should eq source_value }
        end
      end
      context 'when there is no source metadata' do
        context 'but there is native metadata' do
          before { nyucore.send("#{field}=", native_value) }
          it { should eq native_value }
        end
        context 'and there is no native metadata' do
          let(:nyucore) { create(:nyucore, field => nil) }
          it { should be_nil }
        end
      end
    end


    # Test that the fields get set correctly at initialization
    context "when the #{field} value is set at initialization" do
      subject { create(:nyucore, field => value) }
      context "and the value is a String" do
        let(:value) { '1' }
        its(field) { should be_present }
        its(field) { should be_a String }
        its(field) { should eq value }
      end
      context "and the value is an Array" do
        let(:value) { ['1', '2'] }
        its(field) { should be_present }
        its(field) { should be_a String }
        its(field) { should eq value.first }
      end
    end
  end

  # Some meta programming to test all the multi-valued Nyucore attributes
  Nyucore::FIELDS[:multiple].each do |field|
    # Generic test for presence
    its(field) { should be_present }

    # Test the attribute writers
    describe "##{field}=" do
      let(:value) { "Native #{field}" }
      let(:nyucore) { build(:nyucore, field => []) }
      subject { nyucore.send("#{field}=".to_sym, value) }
      it "should set the #{field} attribute" do
        expect(nyucore.send(field)).to be_blank
        subject
        expect(nyucore.send(field)).to be_present
        expect(nyucore.send(field)).to eq [value]
      end
      it "should set the #{field} attribute in the native_metadata datastream" do
        expect(nyucore.native_metadata.send(field)).to be_blank
        subject
        expect(nyucore.native_metadata.send(field)).to be_present
        expect(nyucore.native_metadata.send(field)).to eq [value]
      end
      context 'when the value is correctly passed in as an Array' do
        let(:value) { ['1', '2'] }
        it "should set the #{field} attribute as an Array" do
          expect(nyucore.send(field)).to be_blank
          subject
          expect(nyucore.send(field)).to be_present
          expect(nyucore.send(field)).to eq value
        end
      end
      context 'when the value is incorrectly passed in as a String' do
        let(:value) { '1' }
        it "should set the #{field} attribute as an Array" do
          expect(nyucore.send(field)).to be_blank
          subject
          expect(nyucore.send(field)).to be_present
          expect(nyucore.send(field)).to eq [value]
        end
      end
    end

    # Test the attribute readers
    describe "##{field}" do
      let(:source_value) { 'source value' }
      let(:native_value) { 'native value' }
      subject { nyucore.send(field) }
      it { should be_present }
      it { should be_an Array }
      context 'when there is source metadata' do
        before { nyucore.source_metadata.send("#{field}=", source_value) }
        its(:first) { should eq source_value }
        context 'but there is no native metadata' do
          it { should include source_value }
          it { should_not include native_value }
        end
        context 'and there is native metadata' do
          before { nyucore.send("#{field}=", native_value) }
          it { should include source_value }
          it { should include native_value }
        end
      end
      context 'when there is no source metadata' do
        context 'but there is native metadata' do
          before { nyucore.send("#{field}=", native_value) }
          it { should_not include source_value }
          it { should include native_value }
        end
        context 'and there is no native metadata' do
          it { should_not include source_value }
          it { should_not include native_value }
        end
      end
    end

    # Test that the fields get set correctly at initialization
    context "when the #{field} value is set at initialization" do
      let(:value) { "#{field}" }
      subject { build(:nyucore, field => value) }
      its(field) { should be_present }
      its(field) { should be_an Array }
      its(field) { should include value }
      it "should set the #{field} attribute in the native_metadata datastream" do
        expect(subject.native_metadata.send(field)).to be_present
        expect(subject.native_metadata.send(field)).to include value
      end
      context "and the value is an Array" do
        let(:value) { ['1', '2'] }
        its(field) { should be_present }
        its(field) { should be_an Array }
        its(field) { should eq value }
      end
      context "and the value is a String" do
        let(:value) { '1' }
        its(field) { should be_present }
        its(field) { should be_an Array }
        its(field) { should eq [value] }
      end
    end
  end
end
