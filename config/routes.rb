Rails.application.routes.draw do

  devise_for :users
  resources :users do
    post 'update_stats', on: :collection
    
  end
  
  resources :api_keys do
    post 'sync', on: :member
  end
  resources :exchanges
  resources :orders_histories, only: [:edit, :update, :destroy]

  scope '(:username)' do
    resources :trades do
      get 'debug', on: :collection
      post 'refresh', on: :member
      post 'csv_import', on: :member
    end
  end

  resources :coins do
    get 'load', on: :collection
    post 'load', on: :collection
    delete 'destroy_all', on: :collection, as: "delete"
  end

  resources :wallets do
    get 'load', on: :collection
    post 'load', on: :collection
    delete 'destroy_all', on: :collection, as: "delete"
  end

  get 'console' => 'application#console'
  root to: "application#index"
end
