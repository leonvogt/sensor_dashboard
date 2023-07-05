class API::Authentication::Device
  HMAC_SECRET_KEY = ENV.fetch("API_KEY_HMAC_SECRET_KEY")

  # Plain token is a random string that a client can use to access the API.
  def self.generate_plain_token
    SecureRandom.hex
  end

  # Digest token is a hash of the plain token that is stored in the database.
  def self.generate_digest_token(token)
    OpenSSL::HMAC.hexdigest("SHA256", HMAC_SECRET_KEY, token)
  end

  def self.find_by_token(token)
    digest = OpenSSL::HMAC.hexdigest("SHA256", HMAC_SECRET_KEY, token)
    Device.find_by(access_token: digest)
  end
end
