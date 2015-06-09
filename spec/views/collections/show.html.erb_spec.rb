require 'spec_helper'

describe 'collections/show.html.erb', vcr: {cassette_name: 'views/collections/show'} do
  let(:collection) { create(:collection) }

  before do
    allow(controller).to receive(:current_user).and_return(nil)
    assign(:collection, collection)
  end

      it 'should display  metadata fields labels' do
        render
        assert_select "form[action=?]", collection_path(collection) do

          Collection::SINGLE_FIELDS.each do |field|
            assert_select "label[for=?]", "collection_#{field}", count: 1
          end
          Collection::MULTIPLE_FIELDS.each do |field|
            assert_select "label[for=?]", "collection_#{field}", count: 1
          end
        end
      end
      context 'when collection is not discoverable' do
      let(:collection) { create(:collection, discoverable: "1" ) }
      it 'should display discoverable field as Yes' do
        render
          Collection::ADMIN_FIELDS.each do |field|
            assert_select "label[for=?]", "collection_#{field}", value: 'Yes'
          end
      end
      end
      context 'when collection is not discoverable' do
        let(:collection) { create(:collection, discoverable: "0" ) }
        it 'should display discoverable field as No' do
          render
          Collection::ADMIN_FIELDS.each do |field|
            assert_select "label[for=?]", "collection_#{field}", value: 'No'
          end
        end
      end
 end
