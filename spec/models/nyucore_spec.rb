require 'spec_helper'

describe Nyucore do

  describe Nyucore::NYUCORE_FIELDS do
    subject { Nyucore::NYUCORE_FIELDS }
    it { should be_a Hash }
    it { should have_key :single }
    it { should have_key :multiple }
    it 'should have the appropriate single fields' do
      expect(subject[:single]).to eq [:identifier, :restrictions]
    end
    it 'should have the appropriate multiple fields' do
      expect(subject[:multiple]).to eq [:available, :citation, :title, :creator,
        :type, :publisher, :description, :edition, :date, :format, :language,
        :relation, :rights, :subject, :series, :version]
    end
  end

  describe Nyucore::EXTRA_SINGLES do
    subject { Nyucore::EXTRA_SINGLES }
    it { should eq [:resource_set] }
  end

  describe Nyucore::EXTRA_MULTIPLES do
    subject { Nyucore::EXTRA_MULTIPLES }
    it { should eq [:addinfolink, :addinfotext] }
  end

  describe Nyucore::SINGLE_FIELDS do
    subject { Nyucore::SINGLE_FIELDS }
    it { should eq Nyucore::NYUCORE_FIELDS[:single] + Nyucore::EXTRA_SINGLES }
  end

  describe Nyucore::MULTIPLE_FIELDS do
    subject { Nyucore::MULTIPLE_FIELDS }
    it { should eq Nyucore::NYUCORE_FIELDS[:multiple] + Nyucore::EXTRA_MULTIPLES }
  end

  subject(:nyucore) { build(:nyucore) }
  # Generic test for validity
  it { should be_valid }

  describe '#native_metadata' do
    subject { nyucore.native_metadata }
    it { should be_a Ichabod::NyucoreDatastream }
  end

  describe '#source_metadata' do
    subject { nyucore.source_metadata }
    it { should be_a Ichabod::NyucoreDatastream }
  end

  describe "#collections" do
    subject { nyucore.collections }
    it { should be_instance_of Nyucore::Collections }
  end

  # Some meta programming to test all the single-valued Nyucore attributes
  Nyucore::SINGLE_FIELDS.each do |field|
    # Generic test for validity
    it { should be_valid }
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
      context 'when the value is incorrectly passed in as an Array' do
        let(:value) { ['1', '2'] }
        it "should get the #{field} attribute as a String" do
          expect(nyucore.send(field)).to be_blank
          subject
          expect(nyucore.send(field)).to be_present
          expect(nyucore.send(field)).to eq value.first
        end
      end
      context 'when the value is correctly passed in as a String' do
        let(:value) { '1' }
        it "should get the #{field} attribute as a String" do
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
          let(:nyucore) { build(:nyucore, field => nil) }
          it { should be_nil }
        end
      end
      context 'when the source data is reset', vcr: { cassette_name: "models/nyucore/reset #{field}" } do
        let(:old_value) { "Old #{field}" }
        let(:new_value) { "New #{field}" }
        before do
          nyucore.source_metadata.send("#{field}=", old_value)
          nyucore.save
          nyucore.source_metadata.send("#{field}=", new_value)
          nyucore.save
        end
        it { should_not eq old_value }
        it { should eq new_value }
      end
    end


    # Test that the fields get set correctly at initialization
    context "when the #{field} value is set at initialization" do
      subject { build(:nyucore, field => value) }
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

  # Some meta programming to test all the multi-valued Nyucore attributes and
  # extra Ichabod attributes
  Nyucore::MULTIPLE_FIELDS.each do |field|
    # Generic test for validity
    it { should be_valid }
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
      context 'when the source data is reset', vcr: { cassette_name: "models/nyucore/reset #{field}" } do
        let(:old_value) { "Old #{field}" }
        let(:new_value) { "New #{field}" }
        before do
          nyucore.source_metadata.send("#{field}=", old_value)
          nyucore.save
          nyucore.source_metadata.send("#{field}=", new_value)
          nyucore.save
        end
        it { should_not include old_value }
        it { should include new_value }
      end
    end

    # Test that the fields get set correctly at initialization
    context "when the #{field} value is set at initialization" do
      let(:value) { "#{field}" }
      subject { build(:nyucore, field => value) }
      it { should be_valid }
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
