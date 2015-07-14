require "spec_helper"

describe 'routes for users' do
  describe 'GET /users/auth/nyulibraries' do
    subject { get('/users/auth/nyulibraries') }
    it do
      should route_to({
        controller: 'users/omniauth_callbacks',
        action: 'passthru',
        provider: 'nyulibraries'
      })
    end
  end

  describe 'POST /users/auth/nyulibraries' do
    subject { post('/users/auth/nyulibraries') }
    it do
      should route_to({
        controller: 'users/omniauth_callbacks',
        action: 'passthru',
        provider: 'nyulibraries'
      })
    end
  end

  describe 'GET /users/auth/nyulibraries/callback' do
    subject { get('/users/auth/nyulibraries/callback') }
    it { should route_to({controller: 'users/omniauth_callbacks', action: 'nyulibraries'}) }
  end

  describe 'POST /users/auth/nyulibraries/callback' do
    subject { post('/users/auth/nyulibraries/callback') }
    it { should route_to({controller: 'users/omniauth_callbacks', action: 'nyulibraries'}) }
  end
end
