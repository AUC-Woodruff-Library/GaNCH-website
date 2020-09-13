Rails.application.routes.draw do
  root to: "static_pages#index"

  get "home", to: "static_pages#index"
  get "about", to: "static_pages#about"
  get "export", to: "static_pages#export_instructions"
  get "submit", to: "static_pages#submit"
  get "signup" => "users#new"
  get "login" => "sessions#new"
  get "logout" => "sessions#destroy"

  resources :queries
  get "counties", to: "queries#counties"
  get "regions", to: "queries#regions"
  get "state", to: "queries#state"

  get 'county(/:title)', to: 'queries#show_by_title'
  get 'region(/:title)', to: 'queries#show_by_title'
  resources :users 
  resources :sessions
  resources :recipients

  match 'send_reminders_confirm', to: "reminders#send_reminders_confirm", via: [:delete]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
