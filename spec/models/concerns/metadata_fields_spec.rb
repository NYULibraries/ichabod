require 'spec_helper'

def read_yaml_file
	YAML.load_file(File.join(Rails.root, "config", "metadata_fields.yml"))["terms"]["vocabulary"].deep_symbolize_keys
end

def get_fields_all_sources
	contents = read_yaml_file
	all_fields = []
	contents.keys.each { |ns|
		contents[ns][:fields].keys.each { |f|
			all_fields << f
		}
	}
	all_fields
end

def get_fields_by_source(source, multiple = nil)
	fields = []
	contents = read_yaml_file
	metadata_fields = contents[source][:fields]
	contents[source][:fields].keys.each{ |field|
		output = multiple.nil? ?
		true :
		metadata_fields[field][:multiple] == multiple
		fields << field if output
	}
	fields
end

def get_all_sources_info

end
def get_source_info_by_source(ns)

end


describe MetadataFields do
	let(:invalid_value) { 'foo' }
	let(:all) { MetadataFields.process_metadata_fields }
	let(:single_source_info) { MetadataFields.get_source_info(ns:source) }
	let(:all_sources_info) { MetadataFields.get_source_info }
	let(:dummy_class) { Class.new { include MetadataFields } }


	describe 'process_metadata_fields' do
		it { MetadataFields.should respond_to :process_metadata_fields }

		it 'raises an error if an invalid namespace value is passed to the method' do
			expect { MetadataFields.process_metadata_fields(ns: invalid_value) }.to raise_error
		end

		it 'raises an error if an invalid occurrence value is passed to the method' do
			expect { MetadataFields.process_metadata_fields(multiple: invalid_value) }.to raise_error
		end


		context 'check method returns based on various valid parameters' do
			sources = read_yaml_file
			it 'returns an array if no arguments are sent' do
				expect(all).to be_a_kind_of(Array)
			end

			it 'should equal all fields in the yml file if no arguments are sent' do
				all_fields = get_fields_all_sources
				expect(all).to match_array(all_fields)
			end

			sources.keys.each { |ns|
				ns = ns.to_s
				it "should return fields for a specific sources: #{ns} and no occurrences specified" do
					fields = get_fields_by_source(ns)
					fields_from_module = MetadataFields.process_metadata_fields(ns:ns)
					expect(fields_from_module).to match_array(fields)
				end

				it "should return fields for a specific source: #{ns} and for multiple occurrences" do
					multiple = true
					fields = get_fields_by_source(ns,multiple:multiple)
					fields_from_module = MetadataFields.process_metadata_fields(ns:ns,multiple:multiple)
					expect(fields_from_module).to match_array(fields)
				end

				it "should return fields for a specific source: #{ns} and for single occurrences" do
					multiple = false
					fields = get_fields_by_source(ns,multiple:multiple)
					fields_from_module = MetadataFields.process_metadata_fields(ns:ns,multiple:multiple)
					expect(fields_from_module).to match_array(fields)
				end
			}
		end

		context 'use of process_metadata_fields in an instance of a class' do
			subject { dummy_class.new }
			it { should respond_to(:process_metadata_fields) }
		end
	end

	describe 'get_source_info' do
		it { MetadataFields.should respond_to :get_source_info }

		it 'raises an error if an invalid namespace value is passed to the method' do
			expect { MetadataFields.get_source_info(ns: invalid_value) }.to raise_error
		end

		it 'returns a hash if no arguments are sent' do
			expect(all_sources_info).to be_a_kind_of(Hash)
		end

		it 'returns a hash, if passing a valid value for namespace' do
			expect(single_source_info).to be_an(Hash)
		end

		context 'use of process_metadata_fields in an instance of a class' do
			subject { dummy_class.new }
			it { should respond_to(:get_source_info) }
		end
	end
end
