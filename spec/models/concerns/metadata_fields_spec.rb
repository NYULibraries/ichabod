require 'spec_helper'

describe MetadataFields do
	let(:invalid_value) { 'foo' }
	let(:source) { 'nyucore' }
	let(:all) { MetadataFields.process_metadata_fields }
	let(:single_source) { MetadataFields.process_metadata_fields(ns:source, multiple: false) }
	let(:dummy_class) { Class.new { include MetadataFields } }
	
	describe 'process_metadata_fields' do
		it { MetadataFields.should respond_to :process_metadata_fields }

		it 'raises an error if an invalid namespace value is passed to the method' do 
		    expect { MetadataFields.process_metadata_fields(ns: invalid_value) }.to raise_error
		end

		it 'raises an error if an invalid occurrence value is passed to the method' do 
		    expect { MetadataFields.process_metadata_fields(multiple: invalid_value) }.to raise_error
		end

		it 'returns an array if no arguments are sent' do 
			expect(all).to be_a_kind_of(Array)
		end

		it 'returns an array, if passing valid values for namespace and occurrence' do	    
		    expect(single_source).to be_an(Array)
		end
  	
  	    context 'use of process_metadata_fields in an instance of a class' do
  	       subject { dummy_class.new }
  	       it { should respond_to(:process_metadata_fields) }
  	    end
	end	 
end 
