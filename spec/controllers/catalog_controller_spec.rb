require 'spec_helper'
require 'support/test_user_helper'


describe CatalogController do
  describe "GET /index", vcr: { cassette_name: "controllers/catalog controller/index" } do
    let(:collection_private) { create( :collection_for_gis_cataloger, {:discoverable=>'N'} ) }
    let(:user) { nil }
    before do
      controller.stub(:current_user).and_return(user)
      collection_private.stub(:save)
      create(:nyucore, subject: 'highways')
      get :index, search_field: 'all_fields', q: 'highways'
    end
    it 'should render the index template' do
      expect(response).to render_template(:index)
    end
    it 'should retrieve search results' do
      expect(assigns_response.docs.size).not_to be nil
    end
    it "should return some facets with a search" do
      expect(assigns_response.facets.size).to be > 1
    end
    it "should contain the publisher field in the response" do
      expect(response_qf).to include("desc_metadata__publisher_tesim")
    end
    it "should contain the title field in the response" do
      expect(response_qf).to include("desc_metadata__title_tesim")
    end
    it "should contain the collection field in the response" do
     expect(response_facets).to include("is_part_of_ssim")
    end
    context "when there are restricted collections"  do
      context "when user is not authorized to see specific collection" do
        it "should be filtered in response" do
          expect(response_fq).to include("-is_part_of_ssim:info\\:fedora/#{collection_private.pid.gsub(":","\\:")}")
        end  
      end
      context 'when user is authorized to see specific collection' do
        let(:user) {create(:gis_cataloger )}
        it "should not be filtered in response" do
          expect(response_fq).not_to include("-is_part_of_ssim:info\\:fedora/#{collection_private.pid.gsub(":","\\:")}")
        end
      end
    end

    describe "Blacklight configuration" do
      it "should have facet fields in the correct order" do
        expect(blacklight_configuration.facet_fields.keys).to eq(expected_facet_fields_order)
      end

      it "should have index fields (search result item fields) in the correct order" do
        expect(blacklight_configuration.index_fields.keys).to eq(expected_index_fields_order)
      end

      it "should have show fields (canonical item view fields) in the correct order" do
        expect(blacklight_configuration.show_fields.keys).to eq(expected_show_fields_order)
      end

      describe "'type' facet field" do
        let(:field) { blacklight_facet_field('desc_metadata__type_sim') }

        it "should have correct label" do
          expect(field.label).to eq('Format')
        end
      end

      describe "'available' index field" do
        let(:field) { blacklight_index_field('desc_metadata__available_tesim') }

        it "should have correct helper method" do
          expect(field.helper_method).to eq('render_external_links')
        end
        it "should have correct label" do
          expect(field.label).to eq('Online Resource')
        end
        it "should have correct text" do
          expect(field.text).to eq('resource_text_display')
        end
      end

      describe "'addinfolink' show field" do
        let(:field) { blacklight_show_field('desc_metadata__addinfolink_tesim') }

        it "should have correct helper method" do
          expect(field.helper_method).to eq(:render_external_links)
        end
        it "should have correct label" do
          expect(field.label).to eq('Additional Information')
        end
        it "should have correct text" do
          expect(field.text).to eq('desc_metadata__addinfotext_tesim')
        end
      end
    end
  end

  describe("show_only_discoverable_records") {
    let(:solr_params) { {} }
    let(:user_params) { {} }
    let(:user) { create_or_return_test_admin }
    let(:collection_private) { create(:collection, {:discoverable => 'N'}) }
    before do
      controller.stub(:current_user).and_return(user)
    end
    subject { controller.instance_eval { show_only_discoverable_records({}, {}) } }
    context "when there are restricted collections" do
      context "when user is  authorized to see specific collection" do
        it { should eq [] }
      end
      context 'when user is not authorized to see specific collection' do
        let(:user) { nil }
        it { should include("-is_part_of_ssim:info\\:fedora/#{collection_private.pid.gsub(":", "\\:")}") }
      end
    end
  }

  # Convenience
  def assigns_response
    @controller.instance_variable_get("@response")
  end

  def blacklight_configuration
    @controller.instance_variable_get('@blacklight_config')
  end

  def blacklight_facet_field(field_name)
    blacklight_configuration.facet_fields[field_name]
  end

  def blacklight_index_field(field_name)
    blacklight_configuration.index_fields[field_name]
  end

  def blacklight_show_field(field_name)
    blacklight_configuration.show_fields[field_name]
  end

  def expected_facet_fields_order
    [
        'desc_metadata__type_sim',
        'desc_metadata__creator_sim',
        'desc_metadata__subject_sim',
        'desc_metadata__language_sim',
        'collection_sim'
    ]
  end

  def expected_index_fields_order
    [
        'desc_metadata__title_tesim',
        'desc_metadata__format_ssim',
        'desc_metadata__language_tesim',
        'desc_metadata__publisher_tesim',
        'desc_metadata__restrictions_tesim',
        'desc_metadata__available_tesim',
    ]
  end

  def expected_show_fields_order
    [
        'desc_metadata__title_tesim',
        'desc_metadata__creator_tesim',
        'desc_metadata__title_vern_tesim',
        'desc_metadata__subtitle_tesim',
        'desc_metadata__subtitle_vern_tesim',
        'desc_metadata__author_tesim',
        'desc_metadata__author_vern_tesim',
        'desc_metadata__format_ssim',
        'desc_metadata__url_fulltext_tsim_tesim',
        'desc_metadata__url_suppl_tsim_tesim',
        'desc_metadata__language_tesim',
        'desc_metadata__published_tesim',
        'desc_metadata__published_vern_tesim',
        'desc_metadata__lc_callnum_tesim',
        'desc_metadata__isbn_tesim',
        'desc_metadata__publisher_tesim',
        'desc_metadata__type_tesim',
        'desc_metadata__description_tesim',
        'desc_metadata__series_tesim',
        'desc_metadata__version_tesim',
        'desc_metadata__restrictions_tesim',
        'desc_metadata__available_tesim',
        'desc_metadata__relation_tesim',
        'desc_metadata__location_tesim',
        'desc_metadata__repo_tesim',
        'desc_metadata__data_provider_tesim',
        'desc_metadata__addinfolink_tesim',
        'desc_metadata__rights_tesim'
    ]
  end

  def response_qf
    assigns_response["responseHeader"]["params"]["qf"]
  end

  def response_facets
    assigns_response["responseHeader"]["params"]["facet.field"]
  end

  def response_fq
    assigns_response["responseHeader"]["params"]["fq"]
  end
end
