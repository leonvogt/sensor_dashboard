require 'sidekiq/web'

Rails.application.routes.draw do
  root "dashboard#show"
  get  'dashboard',                  to: 'dashboard#show'
  get  'dashboard_charts',           to: 'dashboard#charts'
  get  'dashboard_last_sensor_data', to: 'dashboard#last_sensor_data'
  resource :health_check, only: :show

  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: :show
  resources :notifications, only: :index

  resources :devices do
    resource :access_token, only: :create
    resources :api_errors, only: :destroy
    resources :sensors, shallow: true do
      resources :alarm_rules, shallow: true
    end
  end

  namespace :api, defaults: { format: :json } do
    # Internal and External API resources are scoped so they don't need to have 'internal' or 'external' in the URL
    scope module: 'external' do
      namespace :v1 do
        resource :sensor_data, only: :create
      end
    end

    scope module: 'internal' do
      namespace :v1 do
        resource :auth, only: [:create, :destroy]
        resource :path_configuration, only: :show
        resources :mobile_app_connections, only: :create
      end
    end
  end
end
