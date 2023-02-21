class DashboardController < ApplicationController
  def show
  end

  def charts
    @devices = current_user.devices.includes(:sensors)
  end
end
