require 'spec_helper'

describe CatalogController do

  describe "GET /index", vcr: { cassette_name: "index search" } do
    it "should retrieve search results" do
      get :index, search_field: 'all_fields', q: 'highways'
      subject { @controller.instance_variable_get("@response") }
      it { expect(subject.docs).to_not be_nil}
      # expect(response).to render_template(:index)
      # assigns_response.docs.size.should > 1
      # assigns_response.facets.size.should > 1
    end
  end

end
