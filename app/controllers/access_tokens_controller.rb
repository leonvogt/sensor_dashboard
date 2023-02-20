class AccessTokensController < ApplicationController
  before_action :set_device

  def create
    plain_token  = access_token_handler.generate_plain_token
    access_token = access_token_handler.generate_digest_token(plain_token)

    if @device.update(access_token: access_token)
      notice = "#{t('successful.messages.created', model: Device.human_attribute_name(:access_token))} Access token: #{plain_token}"
      redirect_to @device, notice: notice
    else
      redirect_to @device, alert: "Access token could not be created"
    end
  end

  private
  def set_device
    @device = Device.find(params[:device_id])
    authorize_resource(@device)
  end

  def access_token_handler
    @_access_token_handler ||= AccessTokenHandler.new
  end
end
