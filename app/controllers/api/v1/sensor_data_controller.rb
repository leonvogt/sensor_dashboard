class Api::V1::SensorDataController < ApplicationController
  include ApiKeyAuthenticatable

  # Deactivate Devise authentication
  # skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # Check for valid API key, before any other action
  # If the API key is invalid, we will return a 401 Unauthorized response
  # prepend_before_action :authenticate_with_api_key!


  def create
    sensor = Sensor.first
    sensor.sensor_data.create!(value: params[:temperature], value_type: 'temp')
    sensor.sensor_data.create!(value: params[:humidity], value_type: 'humidity')
    # binding.pry
    # Parameters: {"token"=>"[FILTERED]", "temperature"=>23, "pressure"=>96562, "altitude"=>424, "humidity"=>37, "sensor_data"=>{"token"=>"[FILTERED]", "temperature"=>23, "pressure"=>96562, "altitude"=>424, "humidity"=>37}}

    render json: { status: 'success' }, status: :ok
  end
end
