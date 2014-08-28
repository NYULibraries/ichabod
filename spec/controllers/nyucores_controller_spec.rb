require 'spec_helper'
require 'support/test_user_helper'

describe NyucoresController do

  let(:user) { create_or_return_test_admin }
  let(:nyucore_fields) { Nyucore::FIELDS[:single] + Nyucore::FIELDS[:multiple] }
  before { controller.stub(:current_user).and_return(user) }

  describe 'GET index', vcr: {cassette_name: 'controllers/nyucores controller/index'} do
    before do
      create(:nyucore)
      get :index
    end
    it 'should assign nyucore records to the item instance variable'  do
     expect(assigns(:items).size).to be > 0
    end
    it 'should render index template'  do
      expect(response).to render_template(:index)
    end
  end

  describe "GET show", vcr: {cassette_name: 'controllers/nyucores controller/show'} do
    let(:item) { create(:nyucore) }
    before { get :show, id: item }
    it 'should retieve specific nyucore record' do
      expect(assigns(:item).id).to eq item.id
    end
  end

  describe "GET new" do
    before { get :new }
    it 'should render new nyucore template' do
      expect(response).to render_template(:new)
    end
    it 'should assign a new nyucore object' do
      expect(assigns(:item)).to be_present
      expect(assigns(:item)).to be_an Nyucore
      expect(assigns(:item)).to be_valid
      expect(assigns(:item)).not_to be_persisted
    end
  end

  describe "POST create", vcr: {cassette_name: 'controllers/nyucores controller/create'} do
    let(:item) { build(:nyucore) }
    it 'should create a new nyucore record' do
      post :create, nyucore: attributes_for(:nyucore, title: ["Only this title"])
      expect(assigns(:item).title).to include "Only this title"
      expect(assigns(:item)).to be_an Nyucore
      expect(assigns(:item)).to be_persisted
      expect(response).to redirect_to nyucore_path(assigns(:item))
    end
    it 'should map attributes to all available fields' do
      post :create, nyucore: attributes_for(:nyucore)
      nyucore_fields.each do |field|
        if (assigns(:item).class.multiple?(field))
          expect(assigns(:item).send(field)).to match_array(item.send(field))
        end
      end
    end
  end

  describe "GET edit", vcr: {cassette_name: 'controllers/nyucores controller/edit'} do
    let(:item) { create(:nyucore) }
    before { get :edit, id: item }
    it 'should render edit nyucore template' do
      expect(assigns(:item)).to render_template(:edit)
    end
    it 'should instantiate an existing nyucore object' do
      expect(assigns(:item)).to_not be_nil
    end
  end

  describe "PUT update", vcr: {cassette_name: 'controllers/nyucores controller/update'} do
    let(:item) { create(:nyucore) }
    let(:another_item) { build(:nyucore) }
    it 'should update an existing nyucore record with a single new attribute' do
      put :update, id: item, nyucore: { title: ["A new title"] }
      expect(assigns(:item).title).to include "A new title"
    end
    it 'should update an existing nyucore record with all new attributes' do
      put :update, id: item, nyucore: attributes_for(:nyucore)
      nyucore_fields.each do |field|
        if (assigns(:item).class.multiple?(field))
          expect(assigns(:item).send(field)).to match_array(another_item.send(field))
        end
      end
    end
  end

  describe "DELETE destroy", vcr: {cassette_name: 'controllers/nyucores controller/destroy'} do
    let!(:item) { create(:nyucore) }
    it 'should delete an existing nyucore record' do
      expect { delete :destroy, id: item }.to change(Nyucore, :count).by(-1)
    end
  end
end
