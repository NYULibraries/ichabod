require 'spec_helper'
describe 'collections/_form.html.erb', vcr: {cassette_name: 'views/collections/_form'} do
  before do
    assign(:collection, collection)
    render 'form', collection: collection
  end

  context 'when the form is rendered for a new collection record' do
    let(:collection) { build(:collection) }
    it 'should display discoverable field as checked' do
      assert_select "input[name=?][type=checkbox][checked=checked]", "collection[discoverable]",  count: 1
    end
    it 'should display input boxes for  metadata fields' do
      assert_select "form[action=?][method=?]", collections_path, "post" 
      Collection::SINGLE_FIELDS.each do |field|
        assert_select "input[id=?]", "collection_#{field}", count: 1
      end
      Collection::MULTIPLE_FIELDS.each do |field|
        assert_select "input[id=?]", "collection_#{field}", count: 1
      end
    end
  end
  context 'when the form is rendered for an existing collection record' do
    let(:collection) { create(:collection) }
    it 'should display populated input boxes for  metadata fields' do
      assert_select "form[action=?][method=?]", collection_path(collection), "post" do
        Collection::SINGLE_FIELDS.each do |field|
          assert_select "input[id=?]", "collection_#{field}", count: 1
        end
        Collection::MULTIPLE_FIELDS.each do |field|
          assert_select "input[id=?]", "collection_#{field}0", count: 1
          assert_select "input[id=?]", "collection_#{field}", count: 1
        end
      end
    end
    context 'when collection is discoverable' do
      it 'should display discoverable field as checked' do
        assert_select "input[name=?][type=checkbox][checked=checked]", "collection[discoverable]", count: 1
      end
    end
    context 'when collection is not discoverable' do
      let(:collection) { create(:collection, discoverable: "0" ) }
      it 'should display discoverable field as unchecked' do
        assert_select "input[name=?][type=checkbox][checked=checked]", "collection[discoverable]", count: 0
      end
    end
  end
end
