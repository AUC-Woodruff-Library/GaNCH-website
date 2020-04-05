Rails.application.routes.draw do
  root to: "queries#index"

  get "about", to: "static_pages#index"
  get "signup" => "users#new"

  resources :queries
  resources :users 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
