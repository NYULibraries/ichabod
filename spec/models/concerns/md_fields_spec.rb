require 'spec_helper'

describe MdFields do
	let(:invalid_value) { 'foo' }
	let(:source) { 'nyucore' }
	let(:all) { MdFields.process_md_fields }
	let(:single_source) { MdFields.process_md_fields(ns:source, multiple: false) }
	let(:dummy_class) { Class.new { include MdFields } }
	
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
		end
  	
  	    context 'use of process_md_fields in an instance of a class' do
  	       subject { dummy_class.new }
  	       it { subject.should be_an_instance_of(dummy_class) }
  	       it { should respond_to(:process_md_fields) }
  	    end
	end	 
end 
