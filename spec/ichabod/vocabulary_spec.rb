require 'spec_helper'
module Ichabod
  describe Vocabulary do
    describe Vocabulary::URI do
      subject { Vocabulary::URI }
      it { should eq 'http://library.nyu.edu/data/ichabod#' }
    end

    describe Vocabulary::TERMS do
      subject { Vocabulary::TERMS }
      it { should be_an Array }
      it { should eq [:addinfolink, :addinfotext, :resource_set, :isbn]}
    end

    # Some metaprogramming to check that the terms are set appropriately
    Vocabulary::TERMS.each do |term|
      describe ".#{term}" do
        subject { Vocabulary.send(term) }
        it { should be_an RDF::Term }
      end
    end

    subject { Vocabulary.new }
    it { should be_a Vocabulary }
    it { should be_a RDF::Vocabulary }
  end
end
