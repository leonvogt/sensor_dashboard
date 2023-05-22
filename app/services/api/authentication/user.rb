class API::Authentication::User
  SIGN_IN_TOKEN_VALIDITY = 1.hour
  def initialize(user)
    @user = user
  end

  def self.try_to_authenticate(params)
    if params[:temporary_sign_in_token].present?
      return API::Authentication::User.find_by_temporary_sign_in_token(params[:temporary_sign_in_token])
    end

    API::Authentication::User.find_by_credentials(params[:email], params[:password])
  end

  def self.find_by_temporary_sign_in_token(token)
    user = User.find_by(temporary_sign_in_token: token)
    return nil if user.blank?
    return nil if new(user).sign_in_token_valid? == false

    new(user).generate_new_sign_in_token!
    user
  end

  def self.find_by_authentication_token(token)
    User.find_by(authentication_token: token)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    user&.valid_password?(password) ? user : nil
  end

  def temporary_sign_in_token_details
    {
      temporary_sign_in_token: temporary_sign_in_token,
      valid_until: @user.temporary_sign_in_token_created_at + SIGN_IN_TOKEN_VALIDITY
    }
  end

  def temporary_sign_in_token
    sign_in_token_valid? ? @user.temporary_sign_in_token : generate_new_sign_in_token!
  end

  def sign_in_token_valid?
    @user.temporary_sign_in_token.present? && @user.temporary_sign_in_token_created_at > (Time.current - SIGN_IN_TOKEN_VALIDITY)
  end

  def generate_new_sign_in_token!
    new_sign_in_token = SecureRandom.hex
    while User.exists?(temporary_sign_in_token: new_sign_in_token)
      new_sign_in_token = SecureRandom.hex
    end

    @user.update!(temporary_sign_in_token: new_sign_in_token, temporary_sign_in_token_created_at: Time.current)
    @user.temporary_sign_in_token
  end
end
