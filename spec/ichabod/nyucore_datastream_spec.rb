require 'spec_helper'
module Ichabod
  describe NyucoreDatastream do
    describe NyucoreDatastream::TERMS do
      subject(:terms) { NyucoreDatastream::TERMS }
      it { should be_an Hash }
      it { should have_key RDF::DC }
      it { should have_key NyucoreMetadata::Vocabulary }
      it { should have_key Ichabod::Vocabulary }
      describe 'RDF::DC' do
        subject { terms[RDF::DC] }
        it { should be_an Array }
        it do
          should eq [:identifier, :title, :creator, :contributor, :publisher,
            :type, :description, :date, :format, :language, :relation, :rights,
            :subject]
        end
      end
      describe 'NyucoreMetadata::Vocabulary' do
        subject { terms[NyucoreMetadata::Vocabulary] }
        it { should be_an Array }
        it do
          should eq [:available, :edition, :series, :version, :citation, :restrictions, :genre]
        end
      end
      describe 'Ichabod::Vocabulary' do
        subject { terms[Ichabod::Vocabulary] }
        it { should be_an Array }
        it do
          should eq [:addinfolink, :addinfotext, :resource_set, :discoverable, :isbn, :geometry, :data_provider, :subject_spatial, :subject_temporal, :location, :repo]
        end
      end
    end

    describe NyucoreDatastream::FACETABLE_TERMS do
      subject { NyucoreDatastream::FACETABLE_TERMS }
      it { should be_an Array }
      it { should eq [:creator, :type, :language, :subject, :isPartOf] }
    end

    subject(:nyucore_datastream) { NyucoreDatastream.new }
    it { should be_an ActiveFedora::NtriplesRDFDatastream }

    # Some metaprogramming to check the attributes accessors
    NyucoreDatastream::TERMS.each_pair do |vocabulary, terms|
      # Somehow some Proc nonsense get injected in this constant by RSpec
      # so we need to make sure we have an Array before setting the examples
      next unless terms.is_a? Array
      terms.each do |term|
        it { should respond_to term }
        it { should respond_to "#{term}=".to_sym }
      end
    end

    describe '#apply_prefix' do
      let(:name) { 'type' }
      subject { nyucore_datastream.apply_prefix(name) }
      it { should eq :desc_metadata__type }
    end
  end
end
