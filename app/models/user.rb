class User < ApplicationRecord
  GUEST_EMAIL    = 'guest@guest.com'
  GUEST_PASSWORD = 'guestPassword!'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :devices, dependent: :destroy
  has_many :sensors, through: :devices
  has_many :sensor_data, through: :sensors

  has_many :mobile_app_connections, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  def guest?
    email == GUEST_EMAIL
  end
end
