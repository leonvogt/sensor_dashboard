class SensorsController < ApplicationController
  before_action :set_sensor, only: [:show, :edit, :update, :destroy]
  before_action :set_device, only: [:new, :create]

  def show
    start_date = params[:timestamp_start].blank? ? Time.current.yesterday : Time.at(params[:timestamp_start].to_i)
    end_date   = params[:timestamp_end].blank?  ? Time.current : Time.at(params[:timestamp_end].to_i)

    sensor_measurements = @sensor.sensor_measurements.where("created_at >= ? AND created_at <= ?", start_date, end_date ).order(created_at: :asc)
    render json: Sensor::SerializeMeasurements.new(@sensor, sensor_measurements).serialize
  end

  def new
    @sensor = @device.sensors.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @sensor.update(sensor_params)
        format.html { redirect_to @sensor.device }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def create
    @sensor  = @device.sensors.new(sensor_params)
    @sensors = @device.sensors.includes(:sensor_measurements)
    @sensor_to_show = params[:sensor_to_show].present? ? Sensor.find(params[:sensor_to_show]) : @sensors.first

    respond_to do |format|
      if @sensor.save
        format.html { redirect_to @sensor.device }
        format.turbo_stream
      else
        format.html { render :new }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private
  def set_sensor
    @sensor = Sensor.find(params[:id])
  end

  def set_device
    @device = Device.find(params[:device_id])
    authorize_resource(@device)
  end

  def sensor_params
    params.require(:sensor).permit(:sensor_type, :chart_type, :show_in_dashboard, alarm_rules_attributes: {})
  end
end
