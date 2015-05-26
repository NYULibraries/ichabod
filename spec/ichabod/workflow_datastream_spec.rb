require 'spec_helper'
module Ichabod
  describe WorkflowDatastream do
    describe WorkflowDatastream::TERMS do
      subject(:terms) { WorkflowDatastream::TERMS }
      it { should be_an Hash }
      it { should have_key Ichabod::Vocabulary }
      describe 'Ichabod::Vocabulary' do
        subject { terms[Ichabod::Vocabulary] }
        it { should be_an Array }
        it do
          should eq [:discoverable]
        end
      end
    end

    subject(:workflow_datastream) { WorkflowDatastream.new }
    it { should be_an ActiveFedora::NtriplesRDFDatastream }

    # Some metaprogramming to check the attributes accessors
    WorkflowDatastream::TERMS.each_pair do |vocabulary, terms|
      # Somehow some Proc nonsense get injected in this constant by RSpec
      # so we need to make sure we have an Array before setting the examples
      next unless terms.is_a? Array
      terms.each do |term|
        it { should respond_to term }
        it { should respond_to "#{term}=".to_sym }
      end
    end
  end
end
