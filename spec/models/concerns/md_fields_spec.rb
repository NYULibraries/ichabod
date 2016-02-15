require 'spec_helper'

describe MdFields do
	let(:bad_call) { MdFields.process_md_fields(ns:'foo') }
	let(:single_source) { MdFields.process_md_fields(ns:'nyucore', multiple: false) }
	let(:multiple_source) { MdFields.process_md_fields(ns:'nyucore', multiple: true) }
	let(:single_all) { MdFields.process_md_fields(multiple: true) }
	let(:all) { MdFields.process_md_fields }

	describe 'process_md_fields' do
		it { MdFields.should respond_to :process_md_fields }

		it 'fails if an invalid namespace value is passed to the method' do 
		    expect { MdFields.process_md_fields(ns:'foo') }.to raise_error
		end

		it 'fails if an invalid occurrence value is passed to the method' do 
		    expect { MdFields.process_md_fields(multiple:'foo') }.to raise_error
		end

		it 'returns an array if no arguments are sent' do 
			expect(all).to be_a_kind_of(Array)
		end

		it 'returns an array, if passing an existing namespace' do 
		    expect(single_source).to be_an(Array)
		end
	end
	 
end 
