require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  resources :meals do
    post :get_random, on: :collection
    member do
      post :toggle_favorite
    end
    get :my_favorites, on: :collection
  end

  resource  :registration, only: %i[new create]
  resource  :session, only: %i[new create destroy]
  resources :passwords, only: %i[new create edit update], param: :token

  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
end
