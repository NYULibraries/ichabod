require 'spec_helper'
describe 'nyucores/_form.html.erb', vcr: {cassette_name: 'views/nyucores/_form'} do
  before do
    assign(:item, item)
    render 'form', item: item
  end
  context 'when the form is rendered for a new nyucore record' do
    let(:item) { build(:nyucore) }
    it 'should not display any source metadata fields' do
      expect(rendered).not_to match /class="source"/
    end
    it 'should display input boxes for native metadata fields' do
      assert_select "form[action=?][method=?]", nyucores_path, "post" do
        Nyucore::FIELDS[:single].each do |field|
          assert_select "input[name=?]", "nyucore[#{field}]", count: 1
        end
        Nyucore::FIELDS[:multiple].each do |field|
          assert_select "input[name=?]", "nyucore[#{field}][]"
        end
      end
    end
  end
  context 'when the form is rendered for an existing nyucore record' do
    let(:item) { create(:nyucore) }
    context "and the existing record doesn't have any source metadata" do
      it 'should not display any source metadata fields' do
        expect(rendered).not_to match /class="source"/
      end
      it 'should display poplulated input boxes for native metadata fields' do
        assert_select "form[action=?][method=?]", nyucore_path(item), "post" do
          Nyucore::FIELDS[:single].each do |field|
            assert_select "input[name=?]", "nyucore[#{field}]", count: 1
          end
          Nyucore::FIELDS[:multiple].each do |field|
            assert_select "input[name=?]", "nyucore[#{field}][]"
          end
        end
      end
    end
    context "and the existing record has source metadata" do
      let(:item) do
        nyucore = create(:nyucore)
        nyucore.source_metadata.title = 'Source title'
        nyucore.save
        nyucore
      end
      it 'should display the source metadata fields as "read-only" text' do
        expect(rendered).to match /class="source"/
      end
      it 'should display populated input boxes for native metadata fields' do
        assert_select "form[action=?][method=?]", nyucore_path(item), "post" do
          Nyucore::FIELDS[:single].each do |field|
            assert_select "input[name=?]", "nyucore[#{field}]", count: 1
          end
          Nyucore::FIELDS[:multiple].each do |field|
            assert_select "input[name=?]", "nyucore[#{field}][]"
          end
        end
      end
    end
  end
end
