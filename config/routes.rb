Ichabod::Application.routes.draw do
  resources :nyucores

  root :to => "catalog#index"
  Blacklight.add_routes(self)

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy', as: :logout
    get 'login', to: redirect("#{Rails.application.config.relative_url_root}/users/auth/nyulibraries"), as: :login
  end
end
