class DashboardController < ApplicationController
  def show
  end

  def charts
    @devices = current_user.devices.includes(:sensors)
  end

  def last_sensor_data
    @sensor_data = current_user.sensor_data.order(created_at: :desc).limit(5)
  end
end
