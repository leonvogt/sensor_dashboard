module API::Internal::V1
  class AuthsController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :authenticate_token!, except: [:create]

    def create
      if (user = User.valid_credentials?(params[:email], params[:password]))
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
      if (user = user_from_token)
        sign_in user, store: false
      else
        head :unauthorized
      end
    end

    def user_from_token
      User.find_by(authentication_token: token) if token.present?
    end

    def token
      request.headers.fetch("Authorization", "").split(" ").last
    end
  end
end