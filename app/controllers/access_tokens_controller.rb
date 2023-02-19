class AccessTokensController < ApplicationController
  before_action :set_sensor

  def create
    plain_token  = access_token_handler.generate_plain_token
    access_token = access_token_handler.generate_digest_token(plain_token)

    if @sensor.update(access_token: access_token)
      notice = "#{t('successful.messages.created', model: Sensor.human_attribute_name(:access_token))} Access token: #{plain_token}"
      redirect_to @sensor, notice: notice
    else
      redirect_to @sensor, alert: "Access token could not be created"
    end
  end

  private
  def set_sensor
    @sensor = Sensor.find(params[:sensor_id])
    authorize_resource(@sensor)
  end

  def access_token_handler
    @_access_token_handler ||= AccessTokenHandler.new
  end
end
