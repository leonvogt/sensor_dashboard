class Api::V1::MobileAppConnectionsController < ApplicationController
  def create
    @mobile_app_connection = MobileAppConnection.find_or_initialize_by(unique_mobile_id: mobile_app_connection_params[:unique_mobile_id])
    if @mobile_app_connection.update(mobile_app_connection_params)
      render json: t('successful.messages.created', model: MobileAppConnection.model_name.human), status: :ok
    else
      render json: { status: 'error', message: @mobile_app_connection.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  private
  def mobile_app_connection_params
    params.require(:mobile_app_connection).permit(:unique_mobile_id, :notification_token, :platform, :app_version).merge(user: current_user)
  end
end
