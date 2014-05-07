require 'spec_helper'

describe NyucoresController do

  let(:item) { create(:nyucore) }
  let(:user) { create(:user) }
  before(:each) { controller.stub(:current_user).and_return(user) }

  describe "GET index", vcr: { cassette_name: "nyucore index search" } do

    it "should retrieve nyucore records"  do
      get :index
      expect(assigns(:items).size).to be > 1
    end

    it "should render index template"  do
      get :index
      expect(assigns(:items)).to render_template(:index)
    end

  end

  describe "GET show", vcr: { cassette_name: "nyucore index show existing" } do

    it "should retieve specific nyucore record" do
      get :show, id: item
      expect(assigns(:item).id).to eql(item.id)
    end

  end

  describe "GET new" do

    it "should render new nyucore template" do
      get :new
      expect(assigns(:item)).to render_template(:new)
    end

    it "should instantiate a new nyucore object" do
      get :new
      expect(assigns(:item)).to_not be_nil
    end

  end

  describe "POST create", vcr: { cassette_name: "nyucore create new" } do

    it "should create a new nyucore record" do
      expect { post :create, nyucore: attributes_for(:nyucore) }.to change(Nyucore, :count)
      expect(assigns(:item)).to be_instance_of(Nyucore)
      expect(assigns(:item).title).to eql(item.title)
    end


  end

  describe "GET edit", vcr: { cassette_name: "nyucore edit existing" } do

    it "should render edit nyucore template" do
      get :edit, id: item
      expect(assigns(:item)).to render_template(:edit)
    end

    it "should instantiate an existing nyucore object" do
      get :edit, id: item
      expect(assigns(:item)).to_not be_nil
    end

  end

  describe "PUT update", vcr: { cassette_name: "nyucore update existing" } do

    it "should update an existing nyucore record" do
      put :update, id: item, nyucore: { title: "A new title" }
      expect(assigns(:item).title).to eql("A new title")
    end

  end

  describe "DELETE destroy", vcr: { cassette_name: "nyucore destroy existing" } do

    it "should delete an existing nyucore record" do
      expect { delete :destroy, id: Nyucore.first }.to change(Nyucore, :count).by(-1)
    end

  end

end
