Rails.application.routes.draw do
  root "dashboard#show"
  get  'dashboard', to: 'dashboard#show'
  devise_for :users

  resources :sensors

  namespace :api do
    namespace :v1 do
      resource :sensor_data, only: :create
    end
  end
end
