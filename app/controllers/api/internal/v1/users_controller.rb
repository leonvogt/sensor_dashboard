module API::Internal::V1
  class UsersController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def create
      user = User.new(user_params)
      if user.save
        sign_in user
        render json: { token: user.authentication_token }
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
