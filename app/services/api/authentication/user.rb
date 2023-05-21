class API::Authentication::User
  def self.find_by_token(token)
    User.find_by!(authentication_token: token)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    user&.valid_password?(password) ? user : nil
  end
end
