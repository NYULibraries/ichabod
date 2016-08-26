require 'spec_helper'
module Ichabod
  module ResourceSet
    module SourceReaders
      describe GitGeoBlacklightReader do
        let(:repo_url) { ENV['GIT_GEO_SPATIAL_MD_URL'] || 'geo_user/git_geo_spatial_md_url'}
        let(:access_token) { ENV['ICHABOD_GIT_USER_TOKEN'] || 'ichabod_git_user_token' }
        let(:collection_code) { 'sdr' }
        let(:resource_set) { mock_resource_set }
        before do
          allow(resource_set).to receive(:repo_url) { repo_url }
          allow(resource_set).to receive(:collection_code) { collection_code }
          allow(resource_set).to receive(:access_token) { access_token }

        end
        subject(:reader) { GitGeoBlacklightReader.new(resource_set) }
        describe '#resource_set' do
          subject { reader.resource_set }
          it { should eq resource_set }
        end
        describe '#read', vcr: {cassette_name: 'resource sets/spatial data repository'} do
          subject(:read) { reader.read }
          it { should be_an Array }
          it { should_not be_empty }
          it 'should include only ResourceSet::Resources' do
            subject.each do |resource|
              expect(resource).to be_a ResourceSet::Resource
            end
          end
          describe 'the first record' do
            subject { read.first }
            its(:prefix) { should eq resource_set.prefix }
            its(:type) { should include 'Geospatial Data' }
            its(:rights) { should include 'Public' }
          end
        end
      end
    end
  end
end
