Rails.application.routes.draw do
  devise_for :users
  # resource :users, only: [:create]
  post '/request_token', to: 'users#request_token'
  post '/search', to: 'spots#search'

  authenticated do
    get '/profile', to: 'users#show'
  end 
end
