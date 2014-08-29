require 'spec_helper'
module Ichabod
  module ResourceSet
    describe Resource, vcr: {cassette_name: 'resource sets/resource'} do
      subject(:resource) { create :resource }
      it { should be_a Resource }
      its(:prefix) { should eq 'prefix' }
      describe '#pid' do
        subject { resource.pid }
        it { should eq "#{resource.prefix}:#{resource.identifier.first}"}
        context 'when the pid identifier is set at initialization' do
          let(:resource) { create :resource, pid_identifier: 'pid_identifier' }
          it { should eq 'prefix:pid_identifier'}
        end
        context 'when the identifier has "."s' do
          let(:resource) { create :resource, identifier: 'this.has.dots' }
          it { should_not include '.' }
          it { should eq 'prefix:this-has-dots'}
        end
        context 'when the identifier has "/"s' do
          let(:resource) { create :resource, identifier: 'this/has/slashes' }
          it { should_not include '/' }
          it { should eq 'prefix:this-has-slashes'}
        end
        context 'when the identifier has "\"s' do
          let(:resource) { create :resource, identifier: 'this\has\backslashes' }
          it { should_not include '\\' }
          it { should eq 'prefix:this-has-backslashes'}
        end
        context 'when the identifier has "http://"s' do
          let(:resource) { create :resource, identifier: 'http://this/is/a/handle' }
          it { should_not include 'http://' }
          it { should eq 'prefix:this-is-a-handle'}
        end
        context 'when the identifier has "https://"s' do
          let(:resource) { create :resource, identifier: 'https://this/is/a/url' }
          it { should_not include 'https://' }
          it { should eq 'prefix:this-is-a-url'}
        end
        context 'when there are multiple identifiers' do
          let(:identifier1) { 'http://example.com' }
          let(:identifier2) { 'http://hdl.handle.net/2451/14097' }
          let(:resource) { create :resource, identifier: [identifier1, identifier2] }
          context 'and the pid identifier is set at initialization' do
            let(:resource) { create :resource, pid_identifier: 'pid_identifier', identifier: [identifier1, identifier2] }
            it { should eq 'prefix:pid_identifier'}
          end
          context 'and one of them is a "handle"' do
            let(:identifier1) { 'Vol. 18, No. 5, September-October 2007' }
            let(:identifier2) { 'http://hdl.handle.net/2451/14097' }
            it { should eq 'prefix:hdl-handle-net-2451-14097'}
            context 'and one of them is a non-handle URL' do
              let(:identifier1) { 'http://example.com' }
              it { should eq 'prefix:hdl-handle-net-2451-14097'}
            end
          end
          context 'and all of them are "handles"' do
            let(:identifier1) { 'http://hdl.handle.net/2451/27761' }
            let(:identifier2) { 'http://hdl.handle.net/2451/14097' }
            it { should eq 'prefix:hdl-handle-net-2451-27761'}
          end
          context 'and none of them are "handles"' do
            context 'and one of them is a non-handle URL' do
              let(:identifier1) { 'an.identifier'}
              let(:identifier2) { 'http://example.com' }
              it { should eq 'prefix:example-com'}
            end
            context 'and one of them is a non-handle URL that is served over SSL' do
              let(:identifier1) { 'an.identifier'}
              let(:identifier2) { 'https://example.com' }
              it { should eq 'prefix:example-com'}
            end
            context 'and all of them are non-handle URL' do
              let(:identifier1) { 'http://an.identifier.net'}
              let(:identifier2) { 'http://example.com' }
              it { should eq 'prefix:an-identifier-net' }
            end
            context 'and none of them are non-handle URL' do
              let(:identifier1) { 'an.identifier' }
              let(:identifier2) { 'another.identifier'}
              it { should eq 'prefix:an-identifier'}
            end
          end
        end
      end
      describe '#to_nyucore' do
        subject { resource.to_nyucore }
        it { should be_an Nyucore }
        it { should_not be_persisted }
        it 'should have a pid' do
          expect(subject.pid).to be_present
        end
      end
      describe '#to_s' do
        subject { resource.to_s }
        it { should be_a String }
        it { should_not be_empty }
        it 'should include the title' do
          expect(subject).to include "pid: #{resource.pid}"
        end
        it 'should include the first title' do
          expect(subject).to include "title: #{resource.title.first}"
        end
      end
    end
  end
end
