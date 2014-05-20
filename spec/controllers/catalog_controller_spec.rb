require 'spec_helper'


describe CatalogController do

  describe "GET /index", vcr: { cassette_name: "catalog index search" } do
    it "should render the index template" do
      get :index, search_field: 'all_fields', q: 'highways'
      expect(assigns_response).to render_template(:index)
    end

    it "should retrieve search results" do
      get :index, search_field: 'all_fields', q: 'highways'
      expect(assigns_response.docs.size).to be > 1
    end

    it "should return some facets with a search" do
      get :index, search_field: 'all_fields', q: 'highways'
      expect(assigns_response.facets.size).to be > 1
    end

    it "should contain the publisher field in the response" do
      get :index, search_field: 'all_fields', q: 'highways'
      expect(response_qf).to include("desc_metadata__publisher_tesim")
    end

    it "should contain the title field in the response" do
      get :index, search_field: 'all_fields', q: 'highways'
      expect(response_qf).to include("desc_metadata__title_tesim")
    end

     it "should retrieve search results when search term is MapPLUTO
      and type is Geospatial Data",
       vcr: { cassette_name: "catalog index search MapPLUTO" } do
       get :index, search_field: 'all_fields', q: 'MapPLUTO', desc_metadata__type_sim: 'Geospatial Data'
       assigns_response["responseHeader"]["params"]["qf"]["desc_metadata__type_sim"]
       expect(assigns_response.total_count).to be > 0
     end
  end

  
  #context "when search term is MapPLUTO and type is Geospatial Data",
     
  #end
  

  def assigns_response
    @controller.instance_variable_get("@response")
  end

  def response_qf
  
    assigns_response["responseHeader"]["params"]["qf"]
    
  end

  end


