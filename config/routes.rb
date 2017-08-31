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

  get 'config', to: 'charts#configuration', format: 'json'
  get 'history', to: 'charts#history', format: 'json'
  get 'time', to: 'charts#time', format: 'text'
  get 'symbols', to: 'charts#symbols', format: 'json'
  get 'marks', to: 'charts#marks', format: 'json'
  get 'timescale_marks', to: 'charts#timescale_marks', format: 'json'
  get 'symbol_info', to: 'charts#symbol_info', format: 'json'
  get 'search', to: 'charts#search', format: 'json'
  get 'quotes', to: 'charts#quotes', format: 'json'

  get 'console' => 'application#console'
  root to: "application#index"
end
