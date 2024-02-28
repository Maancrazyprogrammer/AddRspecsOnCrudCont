Rails.application.routes.draw do
  get "/index", to: 'bookmarks#index'
  resources :bookmarks
  resources :users


  # post "/user", to: "users#create"
  # post "/user/update/:id", to: "users#update"
  # post "/user/destroy/:id", to: "users#destroy"
  # get "/user/:id", to: "users#show"
  # get "/users", to: "users#index"




  # get "/me", to: "users#me"
  # post "/auth/login", to: "auth#login"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
