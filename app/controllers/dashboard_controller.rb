class DashboardController < ApplicationController
  def show
    @sensors = current_user.sensors.includes(:sensor_data, :device)
  end
end
