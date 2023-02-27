class User < ApplicationRecord
  GUEST_EMAIL    = 'guest@guest.com'
  GUEST_PASSWORD = 'guestPassword!'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :devices, dependent: :destroy
  has_many :sensors, through: :devices
  has_many :sensor_data, through: :sensors

  def guest?
    email == GUEST_EMAIL
  end
end
