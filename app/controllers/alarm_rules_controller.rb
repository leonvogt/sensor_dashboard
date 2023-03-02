class AlarmRulesController < ApplicationController
  before_action :set_sensor
  def new
    @alarm_rule = @sensor.alarm_rules.new
  end

  def destroy
    binding.pry
  end

  private
  def set_sensor
    @sensor = Sensor.find(params[:sensor_id])
  end
end
