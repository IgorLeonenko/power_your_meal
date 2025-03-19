Rails.application.routes.draw do
  resources :meals
  resource :registration, only: %i[new create]
  resource :session, only: %i[new create destroy]
  resources :passwords, only: %i[new create edit update], param: :token

  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
end
