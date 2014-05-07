require "spec_helper"

describe NyucoresController do
  describe "routing" do

    it "routes to #index" do
      get("/nyucores").should route_to("nyucores#index")
    end

    it "routes to #new" do
      get("/nyucores/new").should route_to("nyucores#new")
    end

    it "routes to #show" do
      get("/nyucores/1").should route_to("nyucores#show", :id => "1")
    end

    it "routes to #edit" do
      get("/nyucores/1/edit").should route_to("nyucores#edit", :id => "1")
    end

    it "routes to #create" do
      post("/nyucores").should route_to("nyucores#create")
    end

    it "routes to #update" do
      put("/nyucores/1").should route_to("nyucores#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/nyucores/1").should route_to("nyucores#destroy", :id => "1")
    end

  end
end
