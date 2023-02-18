class SensorsController < ApplicationController
  before_action :set_sensor, only: [:show]
  def show
    start_date = params[:timestamp_start].blank? ? Time.current.yesterday : Time.at(params[:timestamp_start].to_i)
    end_date   = params[:timestamp_end].blank?  ? Time.current : Time.at(params[:timestamp_end].to_i)

    sensor_data = @sensor.sensor_data.where("created_at >= ? AND created_at <= ?", start_date, end_date ).order(created_at: :asc)
    render json: SerializeSensorData.new(@sensor, sensor_data).serialize
  end

  private
  def set_sensor
    @sensor = Sensor.find(params[:id])
  end
end
