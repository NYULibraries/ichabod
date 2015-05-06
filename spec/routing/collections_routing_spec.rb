require "spec_helper"

describe CollectionsController do
  describe "routing" do

    it "routes to #index" do
      get("/collections").should route_to("collections#index")
    end

    it "routes to #new" do
      get("/collections/new").should route_to("collections#new")
    end

    it "routes to #show" do
      get("/collections/1").should route_to("collections#show", :id => "1")
    end

    it "routes to #edit" do
      get("/collections/1/edit").should route_to("collections#edit", :id => "1")
    end

    it "routes to #create" do
      post("/collections").should route_to("collections#create")
    end

    it "routes to #update" do
      put("/collections/1").should route_to("collections#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/collections/1").should route_to("collections#destroy", :id => "1")
    end

  end
end
