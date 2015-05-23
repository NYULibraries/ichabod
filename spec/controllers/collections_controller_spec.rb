require 'spec_helper'
require 'support/test_user_helper'

describe CollectionsController do

  let(:user) { create_or_return_test_admin }
  let(:collection_fields) { Collection::COLLECTION_FIELDS[:single] + Collection::COLLECTION_FIELDS[:multiple] }
  before  { controller.stub(:current_user).and_return(user) }

  describe 'GET index' do
    before do
      create(:collection)
      get :index
    end
    it 'should assign collection records to the collection instance variable'  do
     expect(assigns(:collections).size).to be > 0
    end
    it 'should render index template'  do
      expect(response).to render_template(:index)
    end
  end

  describe "GET show" do
    let(:collection) { create(:collection) }
    before { get :show, id: collection }
    it 'should retieve specific collection record' do
      expect(assigns(:collection).id).to eq collection.id
    end
  end

  describe "GET new" do
    before { get :new }
    it 'should render new collection template' do
      expect(response).to render_template(:new)
    end
    it 'should assign a new collection object' do
      expect(assigns(:collection)).to be_present
      expect(assigns(:collection)).to be_an Collection
      expect(assigns(:collection)).not_to be_persisted
    end
  end

  describe "POST create" do
    let(:collection) { build(:collection) }
    it 'should create a new collection record' do
      post :create, collection: attributes_for(:collection, title: "Only this title")
      expect(assigns(:collection).title).to eq("Only this title")
      expect(assigns(:collection)).to be_an Collection
      expect(assigns(:collection)).to be_persisted
      expect(assigns(:collection)).to be_valid
      expect(response).to redirect_to collection_path(assigns(:collection))
    end
    it 'should map attributes to all available fields' do
      post :create, collection: attributes_for(:collection)
      collection_fields.each do |field|
        if (assigns(:collection).class.multiple?(field))
          expect(assigns(:collection).send(field)).to match_array(collection.send(field))
        end
      end
    end
  end

  describe "GET edit" do
    let(:collection) { create(:collection) }
    before { get :edit, id: collection }
    it 'should render edit collection template' do
      expect(assigns(:collection)).to render_template(:edit)
    end
    it 'should instantiate an existing collection object' do
      expect(assigns(:collection)).to_not be_nil
    end
  end

  describe "PUT update" do
    let(:collection) { create(:collection) }
    let(:another_collection) { build(:collection) }
    it 'should update an existing collection record with a single new attribute and redirect to document view' do
      put :update, id: collection, collection: attributes_for(:collection, title: "A new title")
      expect(assigns(:collection).title).to eq("A new title")
      expect response.should redirect_to collection_url
    end
    it 'should update an existing collection record with all new attributes' do
      put :update, id: collection.id, collection: attributes_for(:collection)
      collection_fields.each do |field|
        if (assigns(:collection).class.multiple?(field))
          expect(assigns(:collection).send(field)).to match_array(another_collection.send(field))
        end
      end
    end
  end

  describe "DELETE destroy" do
    let!(:collection) { create(:collection, { :title => "LION" }) }    
    it 'should delete an existing collection record and return to the main page' do
          expect { delete :destroy, id: collection }.to change(Collection, :count).by(-1)
          expect response.should redirect_to collections_url
    end
  end
end
