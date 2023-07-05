class MobileAppConnectionsController < ApplicationController
  before_action :set_mobile_app_connection, only: [:destroy]

  def index
    @mobile_app_connections = current_user.mobile_app_connections
  end

  def new
    qr_code = RQRCode::QRCode.new(API::Authentication::User.new(current_user).temporary_sign_in_token_details.to_json)
    render turbo_stream: turbo_stream.update(
      "remote_modal",
      partial: "new_mobile_app_connection_modal",
      locals: {qr_code: qr_code}
    )
  end

  def destroy
    @mobile_app_connection.destroy
    redirect_to mobile_app_connections_path, notice: t("successful.messages.deleted", model: MobileAppConnection.model_name.human)
  end

  private

  def set_mobile_app_connection
    @mobile_app_connection = MobileAppConnection.find(params[:id])
  end
end
