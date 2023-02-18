class SensorData < ApplicationRecord
  belongs_to :sensor

  validates :value, :value_type, presence: true
  validates :value_type, inclusion: { in: SensorTypes::SENSOR_VALUE_TYPES.values.flatten }
end
