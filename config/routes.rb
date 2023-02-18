Rails.application.routes.draw do
  root "dashboard#show"
  devise_for :users
  resource :dashboard, only: :show

  resources :sensors

  namespace :api do
    namespace :v1 do
      resources :sensor_data, only: :create
    end
  end
end
