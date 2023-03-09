require 'sidekiq/web'

Rails.application.routes.draw do
  root "dashboard#show"
  get  'dashboard',                  to: 'dashboard#show'
  get  'dashboard_charts',           to: 'dashboard#charts'
  get  'dashboard_last_sensor_data', to: 'dashboard#last_sensor_data'

  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resource :health_check, only: :show
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: :show
  resources :mobile_app_connections
  resources :notifications, only: :index

  resources :devices do
    resource :access_token, only: :create
    resources :api_errors, only: :destroy
    resources :sensors, shallow: true do
      resources :alarm_rules, shallow: true
    end
  end

  namespace :api do
    namespace :v1 do
      resource :sensor_data, only: :create
    end
  end
end
