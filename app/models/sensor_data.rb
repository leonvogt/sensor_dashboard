class SensorData < ApplicationRecord
  belongs_to :sensor

  validates :value, presence: true

  def to_s
    [value, SensorConfiguration::SENSOR_TYPE_SUFFIX[sensor.sensor_type]].join(' ')
  end
end
