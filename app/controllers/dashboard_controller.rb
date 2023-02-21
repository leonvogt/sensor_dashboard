class DashboardController < ApplicationController
  def show
  end

  def charts
    @sensors = current_user.sensors.includes(:device)
  end
end
