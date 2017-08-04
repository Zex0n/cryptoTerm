Rails.application.routes.draw do
  # root to: 'visitors#index'
  root to: 'rooms#show'
  devise_for :users
  resources :users
end
