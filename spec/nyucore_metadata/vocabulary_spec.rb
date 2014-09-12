require 'spec_helper'
module NyucoreMetadata
  describe Vocabulary do
    describe Vocabulary::URI do
      subject { Vocabulary::URI }
      it { should eq 'http://harper.bobst.nyu.edu/data/nyucore#' }
    end

    describe Vocabulary::TERMS do
      subject { Vocabulary::TERMS }
      it { should be_an Array }
      it { should eq [:available, :edition, :series, :version, :citation] }
    end

    # Some metaprogramming to check that the terms are set appropriately
    Vocabulary::TERMS.each do |term|
      describe ".#{term}" do
        subject { Vocabulary.send(term) }
        it { should be_an RDF::Term }
      end
    end

    subject(:vocabulary) { Vocabulary.new }
    it { should be_a Vocabulary }
    it { should be_a RDF::Vocabulary }
  end
end
