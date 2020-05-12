Rails.application.routes.draw do
  root "application#index"

  get "login", to: redirect("/auth/discord"), as: "login"
  get "logout", to: "sessions#destroy", as: "logout"
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: "application#index"
  get "me", to: "me#show", as: "me"

  resources :matches, only: %w(index new create)
end
