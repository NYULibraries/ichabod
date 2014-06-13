require 'spec_helper'

describe NyucoresController do

  let(:item) { create(:valid_nyucore) }
  let(:user) { create(:user) }
  let(:nyucore_fields) { [:title, :creator, :publisher, :available, :type, :description, :edition, :series, :version, :date, :format, :language, :relation, :rights, :subject, :citation, :identifier] }
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

    let(:item) { build(:valid_nyucore) }

    it "should create a new nyucore record" do      
      expect { post :create, nyucore: attributes_for(:valid_nyucore) }.to change(Nyucore, :count)
      expect(assigns(:item)).to be_instance_of(Nyucore)
    end

    it "should map attributes to all available fields" do
      post :create, nyucore: attributes_for(:valid_nyucore)
      nyucore_fields.each do |field|
        if (assigns(:item).send(field)).kind_of?(Array)
          expect(assigns(:item).send(field)).to match_array(item.send(field))
        else
          expect(assigns(:item).send(field)).to eql(item.send(field))
        end
      end
    end

    it "should have edit_groups set to public" do
      post :create, nyucore: attributes_for(:valid_nyucore)
          expect(assigns(:item).send('edit_groups')).to match_array(['public'])
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

    it "should update an existing nyucore record with a single new attribute" do
      put :update, id: item, nyucore: { title: "A new title" }
      expect(assigns(:item).title).to eql("A new title")
    end

    let(:another_item) { build(:another_valid_nyucore) }

    it "should update an existing nyucore record with all new attributes" do
      put :update, id: item, nyucore: attributes_for(:another_valid_nyucore)
      nyucore_fields.each do |field|
        if (assigns(:item).send(field)).kind_of?(Array)
          expect(assigns(:item).send(field)).to match_array(another_item.send(field))
        else
          expect(assigns(:item).send(field)).to eql(another_item.send(field))
        end
      end
    end

  end

  describe "DELETE destroy", vcr: { cassette_name: "nyucore destroy existing" } do

    it "should delete an existing nyucore record" do
      expect { delete :destroy, id: Nyucore.first }.to change(Nyucore, :count).by(-1)
    end

  end

end
