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
    it "should contain the colection field in the response" do
      expect(response_facets).to include("collection_sim")
    end
  end

  # Convenience
  def assigns_response
    @controller.instance_variable_get("@response")
  end

  def response_qf
    assigns_response["responseHeader"]["params"]["qf"]
  end

  def response_facets
    assigns_response["responseHeader"]["params"]["facet.field"]
  end
end
