Rails.application.routes.draw do
  # root to: 'visitors#index'
  root to: 'rooms#show'
  get '/config', to: 'patients#show'
  devise_for :users
  resources :users
end
