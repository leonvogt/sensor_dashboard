class Api::V1::SensorDataController < ApplicationController
  include ApiKeyAuthenticatable

  # Deactivate Devise authentication
  skip_before_action :authenticate_user!

  # Deactivate CSRF protection, because we are using an API key
  skip_before_action :verify_authenticity_token

  # Check for valid API key, before any other action
  # If the API key is invalid, we will return a 401 Unauthorized response
  prepend_before_action :authenticate_with_api_key!


  def create
    ActiveRecord::Base.transaction do
      sensor_value_params.each do |sensor_type, value|
        begin
          sensor_data = @current_device.sensors.find_by!(sensor_type: sensor_type).sensor_data.create!(value: value)
          broadcast_new_sensor_data(sensor_data)
        rescue ActiveRecord::RecordNotFound
          error_message = I18n.t('errors.api_error.sensor_not_found', sensor_type: sensor_type)
          @current_device.api_errors.create!(error_message: error_message)
          render json: { status: 'error', message: error_message }, status: :unprocessable_entity
          return
        end
      end
    end

    render json: { status: 'success' }, status: :ok
  end

  private
  def sensor_value_params
    params.require(:sensor_values)
  end

  def broadcast_new_sensor_data(sensor_data)
    Broadcast::add_sensor_data_to_chart("sensor-show-page", sensor_data)
    Broadcast::add_sensor_data_to_chart("dashboard", sensor_data)
  end
end
