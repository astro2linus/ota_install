Rails.application.routes.draw do

  use_doorkeeper

  namespace :api, defaults: { format: :json } do 
    namespace :v1 do
      resources :products do
        resources :releases
        get 'download', on: :member, as: :latest_download
      end

      resources :ios_releases do 
        get 'download', on: :member
      end
      resources :android_releases do
        get 'download', on: :member
      end
    end
  end
  
  root 'products#index'
  get 'products/upload', as: :upload
  get 'manifests/:id' => 'manifests#show', as: :manifest, :defaults => { :format => :xml }
  get '/ssl_test' => 'manifests#ssl_test'
  get '/install_certificate' => 'home#install_certificate'
  get 'login' => 'sessions#new', as: :login
  get 'login' => 'sessions#create', as: :signup
  get '/logout' => 'sessions#destroy'
  get '/auth/failure', to: 'sessions#failure'
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]

  resources :identities

  resources :products do 
    resources :releases
    resources :groups
    get 'download', on: :member, as: :latest_download
  end

  resources :releases do
    get 'download', on: :member
  end
  resources :ios_releases
  resources :android_releases
 
  resources :users, only: [:show, :index]
  resources :groups
end
