require 'spec_helper'

def read_yaml_file
	YAML.load_file(File.join(Rails.root, "spec/fixtures", "fixture_metadata_fields.yml"))["terms"]["vocabulary"].deep_symbolize_keys
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
	s = source
	source = source.to_sym
	metadata_fields = contents[source][:fields]
	metadata_fields.keys.each{ |field|
		output = multiple.nil? ?
		true :
		metadata_fields[field][:multiple] == multiple
		fields << field if output
	}
	fields
end

def get_all_sources_info
	contents = read_yaml_file
	info = {}
	contents.keys.each { |ns|
		info[ns] = get_info_by_source(ns)
	}
	info
end

def get_info_by_source(ns)
	contents = read_yaml_file
	ns = ns.to_sym
	info = contents[ns][:info]
end


describe MetadataFields do
	let(:invalid_value) { 'foo' }
	let(:all_fields) { MetadataFields.process_metadata_fields }
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
				expect(all_fields).to be_a_kind_of(Array)
			end

			it 'should equal all fields in the yml file if no arguments are sent' do
				all = get_fields_all_sources
				expect(all_fields).to match_array(all)
			end

			sources.keys.each { |ns|
				ns = ns.to_s
				it "should return fields for a specific source: #{ns} and no occurrences specified" do
					fields = get_fields_by_source(ns)
					fields_from_module = MetadataFields.process_metadata_fields(ns:ns)
					expect(fields_from_module).to match_array(fields)
				end

				it "should return fields for a specific source: #{ns} and for multiple occurrences" do
					multiple = true
					fields = get_fields_by_source(ns,multiple)
					fields_from_module = MetadataFields.process_metadata_fields(ns:ns,multiple:multiple)
					expect(fields_from_module).to match_array(fields)
				end

				it "should return fields for a specific source: #{ns} and for single occurrences" do
					multiple = false
					fields = get_fields_by_source(ns,multiple)
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
		context 'check method returns based on various valid parameters' do
			sources = read_yaml_file

			it 'returns a hash if no arguments are sent' do
				expect(all_sources_info).to be_a_kind_of(Hash)
			end
			context 'return the correct information when no source is specified' do
				all_info = get_all_sources_info
				it 'should return all sources' do
					all_info_keys = all_info.keys
					all_sources_info_keys = all_sources_info.keys
					expect(all_sources_info_keys).to match_array(all_info_keys)
				end

				it 'should return the corresponding information hashes' do
					all_info.each_pair { |source, info_hash|
						expect(all_sources_info[source]).to match_ichabod_source_uri_hash(info_hash)
					}
				end
			end

			sources.keys.each { |ns|
				ns = ns.to_s
				it "returns a hash, if passing a valid value for namespace: #{ns}" do
					info = get_info_by_source(ns)
					info_from_module = MetadataFields.get_source_info(ns:ns)
					expect(info_from_module).to include(info)
				end
			}
		end

		context 'use of process_metadata_fields in an instance of a class' do
			subject { dummy_class.new }
			it { should respond_to(:get_source_info) }
		end
	end
end
