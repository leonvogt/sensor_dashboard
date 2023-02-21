class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :devices, dependent: :destroy
  has_many :sensors, through: :devices
  has_many :sensor_data, through: :sensors
end
