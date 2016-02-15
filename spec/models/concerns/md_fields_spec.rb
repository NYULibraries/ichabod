require 'spec_helper'

describe MdFields do
	let(:invalid_value) { 'foo' }
	let(:single_source) { MdFields.process_md_fields(ns:'nyucore', multiple: false) }
	let(:multiple_source) { MdFields.process_md_fields(ns:'nyucore', multiple: true) }
	let(:single_all) { MdFields.process_md_fields(multiple: true) }
	let(:all) { MdFields.process_md_fields }
	#let!(:single_occ_valid_values) do
		 ##fields = []
		 MD_FIELDS[:nyucore].keys.each do |field|
		 ##	multiple = MD_FIELDS[:nyucore][field][:multiple]
		  #  fields.push(field) if multiple == false
		 #end
    #end

	describe 'process_md_fields' do
		it { MdFields.should respond_to :process_md_fields }

		it 'fails if an invalid namespace value is passed to the method' do 
		    expect { MdFields.process_md_fields(ns: invalid_value) }.to raise_error
		end

		it 'fails if an invalid occurrence value is passed to the method' do 
		    expect { MdFields.process_md_fields(multiple: invalid_value) }.to raise_error
		end

		it 'returns an array if no arguments are sent' do 
			expect(all).to be_a_kind_of(Array)
		end

		it 'returns an array, if passing valid values for namespace and occurrence' do	    
		    expect(single_source).to be_an(Array)
		    #single_source.should =~ single_occ_valid_values
		end

		
	end
    
	
	 
end 
