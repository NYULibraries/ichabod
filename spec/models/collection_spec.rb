require 'spec_helper'

describe Collection do

describe Collection::COLLECTION_FIELDS do
    subject { Collection::COLLECTION_FIELDS }
    it { should be_a Hash }
    it { should have_key :single }
    it { should have_key :multiple }
    it { should have_key :workflow }
    it 'should have the appropriate single fields' do
      expect(subject[:single]).to eq [ :title,:description,:rights ]
    end
    it 'should have the appropriate multiple fields' do
      expect(subject[:multiple]).to eq [ :creator, :publisher ]
    end
    it 'should have the appropriate workflow fields' do
      expect(subject[:workflow]).to eq [ :discoverable]
    end
  end

  
  subject(:collection) { build(:collection) }
  # Generic test for validity
  it { should be_valid }

end