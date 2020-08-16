Rails.application.routes.draw do
  devise_for :users
  # resource :users, only: [:create]
  post '/request_token', to: 'users#request_token'

  get '/profile', to: 'users#show'

  post '/search', to: 'spots#search'
end
