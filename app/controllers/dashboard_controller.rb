class DashboardController < ApplicationController
  def show
  end

  def charts
    @devices = current_user.devices.includes(:sensors)
  end

  def last_sensor_measurements
    @sensor_measurements = current_user.sensor_measurements.order(created_at: :desc).limit(5)
  end
end
