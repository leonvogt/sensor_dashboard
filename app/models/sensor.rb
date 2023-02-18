class Sensor < ApplicationRecord
  belongs_to :user
  has_many :sensor_data, dependent: :destroy

  validates :name, presence: true

  def supported_value_types
    SensorTypes::SENSOR_VALUE_TYPES[sensor_type]
  end
end
