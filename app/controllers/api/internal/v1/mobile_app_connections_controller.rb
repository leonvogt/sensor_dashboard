module API::Internal::V1
  class MobileAppConnectionsController < API::Internal::V1::AuthsController
    before_action :set_mobile_app_connection, only: [:destroy]

    def index
      @mobile_app_connections = current_user.mobile_app_connections
    end

    # The create action will be called from the mobile app when user logs in
    def create
      mobile_app_connection = MobileAppConnection.find_or_initialize_by(notification_token: mobile_app_connection_params[:notification_token])
      if mobile_app_connection.update(mobile_app_connection_params)
        render json: t('successful.messages.created', model: MobileAppConnection.model_name.human), status: :ok
      else
        render json: { status: 'error', message: mobile_app_connection.errors.full_messages.join(' ') }, status: :unprocessable_entity
      end
    end

    def destroy
      @mobile_app_connection.destroy
      redirect_to mobile_app_connections_path, notice: t('successful.messages.deleted', model: MobileAppConnection.model_name.human)
    end

    private
    def set_mobile_app_connection
      @mobile_app_connection = MobileAppConnection.find(params[:id])
    end

    def mobile_app_connection_params
      params.permit(:notification_token, :platform, :app_version).merge(user: current_user)
    end
  end
end
