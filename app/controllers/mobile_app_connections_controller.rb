class MobileAppConnectionsController < ApplicationController
  before_action :set_mobile_app_connection, only: [:destroy]

  def index
    @mobile_app_connections = current_user.mobile_app_connections
  end

  def destroy
    @mobile_app_connection.destroy
    redirect_to mobile_app_connections_path, notice: t('successful.messages.deleted', model: MobileAppConnection.model_name.human)
  end

  private
  def set_mobile_app_connection
    @mobile_app_connection = MobileAppConnection.find(params[:id])
  end
end
