Rails.application.routes.draw do
  get 'config', to: 'charts#configuration', format: 'json'
  get 'history', to: 'charts#history', format: 'json'
  get 'time', to: 'charts#time', format: 'text'
  get 'symbols', to: 'charts#symbols', format: 'json'
  get 'marks', to: 'charts#marks', format: 'json'
  get 'timescale_marks', to: 'charts#timescale_marks', format: 'json'
  get 'symbol_info', to: 'charts#symbol_info', format: 'json'
  get 'search', to: 'charts#search', format: 'json'
  get 'quotes', to: 'charts#quotes', format: 'json'

  # root to: 'visitors#index'
  root to: 'rooms#show'
  devise_for :users
  resources :users
end
