require 'spec_helper'
require 'support/test_user_helper'


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
      expect(response_facets).to include("desc_metadata__isPartOf_sim")
    end
    context "when there are restricted collections"  do
      context "when user is not authorized to see specific collection" do
        it "should be filtered in response" do
          expect(response_fq).to include("-desc_metadata__isPartOf_sim")
        end  
      end
      context 'when user is authorized to see specific collection' do
      let(:user) { create_or_return_test_admin }
        before  do
          controller.stub(:current_user).and_return(user)
          get :index, search_field: 'all_fields', q: 'highways'
        end
        it "should not be filtered in response" do
          expect(response_fq).to be nil
        end
      end
    end
  end

  describe "show_only_discoverable_records" do  
    let(:solr_params) { {} }
    let(:user_params) { {} }
    let(:user) { create_or_return_test_admin }
    before do
      controller.stub(:current_user).and_return(user)
    end
    subject { controller.instance_eval{ show_only_discoverable_records({},{}) } }
    context "when there are restricted collections"  do
      context "when user is not authorized to see specific collection" do
        it { should eq nil }
      end
      context 'when user is authorized to see specific collection' do
        let(:user) { nil }
        it { should eq [["-collection_sim:Indian*"]] }
      end
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

  def response_fq
    assigns_response["responseHeader"]["params"]["fq"]
  end
end
