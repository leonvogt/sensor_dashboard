Rails.application.routes.draw do
  root "dashboard#show"
  get  'dashboard',                  to: 'dashboard#show'
  get  'dashboard_charts',           to: 'dashboard#charts'
  get  'dashboard_last_sensor_data', to: 'dashboard#last_sensor_data'

  devise_for :users
  resources :devices do
    resource :access_token, only: :create
    resources :sensors, shallow: true
    resources :api_errors, only: :destroy
  end

  namespace :api do
    namespace :v1 do
      resource :sensor_data, only: :create
    end
  end
end
