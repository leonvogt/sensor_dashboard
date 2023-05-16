class SensorMeasurement < ApplicationRecord
  belongs_to :sensor
  has_many :alarm_rules, through: :sensor

  validates :value, presence: true

  def to_s
    [value, Sensor::ConfigurationOptions::SENSOR_TYPE_SUFFIX[sensor.sensor_type]].join(' ')
  end
end
