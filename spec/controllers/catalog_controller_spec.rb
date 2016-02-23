require 'spec_helper'
describe CatalogController do
  describe "GET /index", vcr: { cassette_name: "controllers/catalog controller/index" } do
    before do
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
      expect(response_facets).to include("collection_sim")
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

      describe "'available' index field" do
        let(:field) { blacklight_index_field('desc_metadata__available_tesim') }

        it "should have correct helper method" do
          expect(field.helper_method).to eq(:render_external_links)
        end
        it "should have correct label" do
          expect(field.label).to eq('Online Resource')
        end
        it "should have correct text" do
          expect(field.text).to eq('resource_text_display')
        end
      end

    end
  end

  # Convenience
  def assigns_response
    @controller.instance_variable_get("@response")
  end

  def blacklight_configuration
    @controller.instance_variable_get('@blacklight_config')
  end

  def blacklight_index_field(field_name)
    blacklight_configuration.index_fields[field_name]
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
        'desc_metadata__title_vern_tesim',
        'desc_metadata__author_tesim',
        'desc_metadata__author_vern_tesim',
        'desc_metadata__format_ssim',
        'desc_metadata__language_tesim',
        'desc_metadata__published_tesim',
        'desc_metadata__published_vern_tesim',
        'desc_metadata__lc_callnum_tesim',
        'desc_metadata__publisher_tesim',
        'desc_metadata__restrictions_tesim',
        'desc_metadata__available_tesim',
        'desc_metadata__id_tesim'
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
end
