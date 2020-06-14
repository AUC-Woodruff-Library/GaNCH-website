Rails.application.routes.draw do
  root to: "static_pages#index"

  get "home", to: "static_pages#index"
  get "about", to: "static_pages#about"
  get "signup" => "users#new"
  get "login" => "sessions#new"
  get "logout" => "sessions#destroy"

  resources :queries
  resources :users 
  resources :sessions
  resources :recipients
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
