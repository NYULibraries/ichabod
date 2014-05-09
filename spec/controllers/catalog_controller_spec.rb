require 'spec_helper'
require 'webmock'
WebMock.disable_net_connect!(:allow_localhost => true)

describe CatalogController do

  describe "GET /catalog/", vcr: { cassette_name: "catalog index search" } do


    it "should retrieve search results for GeoSpatial dataset with known title" do
      get :index, search_field: 'all_fields', q: 'MapPLUTO', desc_metadata__type_sim: "Geospatial+Data"
      expect(assigns_response.total_count).to be > 0
    end


  end

  def assigns_response
    @controller.instance_variable_get("@response")
  end

  def response_qf
    assigns_response["responseHeader"]["params"]["qf"]["desc_metadata__type_sim"]
  end

end
