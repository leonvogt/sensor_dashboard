module API::Internal::V1
  class AuthsController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :authenticate_token!

    def create
      if user = API::Authentication::User.find_by_credentials(params[:email], params[:password])
        sign_in user
        render json: { token: user.authentication_token }
      else
        render json: { error: I18n.t("devise.failure.invalid", authentication_keys: :email) }, status: :unauthorized
      end
    end

    def destroy
      sign_out(current_user)
      render json: {}
    end

    private

    def authenticate_token!
      # Skip token authentication for the create action
      # (On the first login, the user won't have a token yet and will be authenticated by email and password)
      return if controller_name == 'auths' && action_name == 'create'

      if user = API::Authentication::User.find_by_token(token)
        sign_in user
      else
        head :unauthorized
      end
    end

    def token
      request.headers.fetch("Authorization", "").split(" ").last
    end
  end
end
