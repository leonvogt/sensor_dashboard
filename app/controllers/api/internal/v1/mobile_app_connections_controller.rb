module API::Internal::V1
  class MobileAppConnectionsController < API::Internal::V1::AuthsController
    def create
      mobile_app_connection = MobileAppConnection.find_or_initialize_by(notification_token: mobile_app_connection_params[:notification_token])
      if mobile_app_connection.update(mobile_app_connection_params)
        render json: t('successful.messages.created', model: MobileAppConnection.model_name.human), status: :ok
      else
        render json: { status: 'error', message: mobile_app_connection.errors.full_messages.join(' ') }, status: :unprocessable_entity
      end
    end

    private
    def mobile_app_connection_params
      params.permit(:notification_token, :platform, :app_version).merge(user: current_user)
    end
  end
end
