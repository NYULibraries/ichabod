require 'spec_helper'

def fixture
  YAML.load_file(File.join(Rails.root, "spec/fixtures", "fixture_metadata_fields.yml")).deep_symbolize_keys
end

def fixture_vocabulary
	fixture[:terms][:vocabulary]
end

def get_field_names_all_sources
  contents = fixture_vocabulary
  all_field_names = []
  contents.keys.each { |ns|
    contents[ns][:fields].keys.each { |f|
      all_field_names << f
    }
  }
  all_field_names
end

def get_field_names_by_source(source, multiple = nil)
  field_names = []
  contents = fixture_vocabulary
  s = source
  source = source.to_sym
  metadata_fields = contents[source][:fields]
  metadata_fields.keys.each{ |field|
    output = multiple.nil? ?
    true :
    metadata_fields[field][:multiple] == multiple
    field_names << field if output
  }
  field_names
end

def get_all_sources_info
  contents = fixture_vocabulary
  info = {}
  contents.keys.each { |ns|
    info[ns] = get_info_by_source(ns)
  }
  info
end

def get_info_by_source(ns)
  contents = fixture_vocabulary
  ns = ns.to_sym
  info = contents[ns][:info]
end

def expected_facet_fields_order
  [
    :type,
    :creator,
    :subject,
    :language
  ]
end

def expected_search_result_fields_order
  [
    :title,
    :format,
    :language,
    :publisher,
    :restrictions,
    :available
  ]
end

def expected_detail_fields_order
  [
    :title,
    :creator,
    :format,
    :language,
    :isbn,
    :publisher,
    :type,
    :description,
    :series,
    :version,
    :restrictions,
    :available,
    :relation,
    :location,
    :repo,
    :data_provider,
    :addinfolink,
    :rights
  ]
end

def expected_title_solr_opts
  [
    :stored_searchable,
    {:type=>:string}
  ]
end

describe MetadataFields do
  let(:invalid_value) { 'foo' }

  describe 'process_metadata_field_names' do
    it 'raises an error if an invalid namespace value is passed to the method' do
      expect { MetadataFields.process_metadata_field_names(ns: invalid_value) }.to raise_error
    end

    it 'raises an error if an invalid occurrence value is passed to the method' do
      expect { MetadataFields.process_metadata_field_names(multiple: invalid_value) }.to raise_error
    end

    context 'check method returns based on various valid parameters' do
      sources = fixture_vocabulary
      let(:all_fields_expected) { MetadataFields.process_metadata_field_names }
      it 'returns an array if no arguments are sent' do
        expect(all_fields_expected).to be_a_kind_of(Array)
      end

      it 'should equal all fields in the yml file if no arguments are sent' do
        all = get_field_names_all_sources
        expect(all_fields_expected).to match_array(all)
      end

      sources.keys.each { |ns|
        ns = ns.to_s
        it "should return fields for a specific source: #{ns} and no occurrences specified" do
          fields = get_field_names_by_source(ns)
          expect(MetadataFields.process_metadata_field_names(ns:ns)).to match_array(fields)
        end

        it "should return fields for a specific source: #{ns} and for multiple occurrences" do
          multiple = true
          fields = get_field_names_by_source(ns, multiple)
          expect(MetadataFields.process_metadata_field_names(ns:ns, multiple:multiple)).to match_array(fields)
        end

        it "should return fields for a specific source: #{ns} and for single occurrences" do
          multiple = false
          fields = get_field_names_by_source(ns, multiple)
          expect(MetadataFields.process_metadata_field_names(ns:ns, multiple:multiple)).to match_array(fields)
        end
      }
    end
  end

  describe 'get_source_info' do
    it 'raises an error if an invalid namespace value is passed to the method' do
      expect { MetadataFields.get_source_info(ns: invalid_value) }.to raise_error
    end
    context 'check method returns based on various valid parameters' do
      sources = fixture_vocabulary
      let(:all_source_info_expected) { MetadataFields.get_source_info }
      it 'returns a hash if no arguments are sent' do
        expect(all_source_info_expected).to be_a_kind_of(Hash)
      end
      context 'return the correct information when no source is specified' do
        all_info = get_all_sources_info
        it 'should return all sources' do
          expect(all_source_info_expected.keys).to match_array(all_info.keys)
        end

        it 'should return the corresponding information hashes' do
          all_info.each_pair { |source, info_hash|
            expect(all_source_info_expected[source]).to match_ichabod_source_uri_hash(info_hash)
          }
        end
      end

      sources.keys.each { |ns|
        ns = ns.to_s
        it "returns a hash, if passing a valid value for namespace: #{ns}" do
          info = get_info_by_source(ns)
          expect(MetadataFields.get_source_info(ns:ns)).to match_ichabod_source_uri_hash(info)
        end
      }
    end
  end

  describe 'add_all_fields' do
    it 'returns correct fields for all' do
      fields = []
      MetadataFields.add_all_fields('all', fields)
      expect(fields.length).to eq(get_field_names_all_sources.length)
      all_names = fields.map do |field|
        field[:name]
      end
      expect(all_names).to eq(get_field_names_all_sources)
    end
  end

  describe 'add_fields_by_ns' do
    it 'returns correct fields for dublin core' do
      fields = []
      MetadataFields.add_fields_by_ns('all', fields, :dcterms)
      expect(fields.length).to eq(get_field_names_by_source(:dcterms, multiple = nil).length)
      dcterms_names = fields.map do |field|
        field[:name]
      end
      expect(dcterms_names).to eq(get_field_names_by_source(:dcterms, multiple = nil))
    end
    it 'returns correct attributes for addinfolink field' do
      fields = []
      MetadataFields.add_all_fields('all', fields)
      addinfolink_field = fields.select do |field|
        field[:name] == :addinfolink
      end
      expect(addinfolink_field[0][:attributes][:display][:detail][:special_handling][:helper_method]).to be
      expect(addinfolink_field[0][:attributes][:display][:detail][:special_handling][:helper_method]).to be
      expect(addinfolink_field[0][:attributes].length).to eql(8)

    end
  end

  describe 'get_facet_fields_in_display_order' do
    it 'returns fields in correct order' do
      field_names = MetadataFields.get_facet_fields_in_display_order.map do |field|
        field[:name]
      end
      expect(field_names).to eq(expected_facet_fields_order)
    end
  end

  describe 'get_search_result_fields_in_display_order' do
    it 'returns fields in correct order' do
      field_names = MetadataFields.get_search_result_fields_in_display_order.map do |field|
        field[:name]
      end
      expect(field_names).to eq(expected_search_result_fields_order)
    end
  end

  describe 'get_detail_fields_in_display_order' do
    it 'returns fields in correct order' do
      field_names = MetadataFields.get_detail_fields_in_display_order.map do |field|
        field[:name]
      end
      expect(field_names).to eq(expected_detail_fields_order)
    end
  end

  describe 'get_fields_for_section_in_display_order' do
    it 'works if passed a symbol' do
      field_names = MetadataFields.get_fields_for_section_in_display_order(:facet).map do |field|
        field[:name]
      end

      expect(field_names).to eq(expected_facet_fields_order)
    end

    it 'works if passed a string instead of a symbol' do
      field_names = MetadataFields.get_fields_for_section_in_display_order('facet').map do |field|
        field[:name]
      end

      expect(field_names).to eq(expected_facet_fields_order)
    end

    it 'raises nil ArgumentError when passed nil' do
      expect {
        MetadataFields.get_fields_for_section_in_display_order nil
      }.to raise_error(ArgumentError, '"section" argument is nil')
    end

    it 'raises "section not found" ArgumentError when passed non-existent section' do
      bad_section = 'nonexistent_section_xyz'
      expect {
        MetadataFields.get_fields_for_section_in_display_order bad_section
      }.to raise_error(ArgumentError, /section "#{bad_section}" not found for field "\w+"/)
    end
  end

  describe 'sort_fields_by_display_attribute' do
    fields = []
    MetadataFields.add_all_fields('all', fields)
    fields = fields.select do |field|
      field[:attributes][:display][:facet][:show] == true
    end
    it 'sorts fields by section' do
      field_names = MetadataFields.sort_fields_by_display_attribute(fields, :facet, :sort_key).map do |field|
        field[:name]
      end

      expect(field_names).to eq(expected_facet_fields_order)
    end
  end

  describe 'get_solr_name_opts' do
    fields = []
    MetadataFields.add_all_fields('all', fields)
    title_field = fields.select do |field|
      field[:name] == :title
    end
    it 'returns the correct solr options for "title" field' do
      opts =  MetadataFields.get_solr_name_opts(title_field[0])

      expect(opts).to eq(expected_title_solr_opts)
    end
  end

end
