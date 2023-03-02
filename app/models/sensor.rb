class Sensor < ApplicationRecord
  belongs_to :device
  delegate :user, to: :device

  has_many :sensor_data, dependent: :destroy
  has_many :alarm_rules, dependent: :destroy

  scope :shown_in_dashboard, -> { where(show_in_dashboard: true) }

  validates :sensor_type, :chart_type, :device, presence: true

  accepts_nested_attributes_for :alarm_rules, allow_destroy: true

  def to_s
    I18n.t(sensor_type, scope: 'sensors.sensor_types')
  end

  def value_suffix
    SensorConfiguration::SENSOR_TYPE_SUFFIX[sensor_type]
  end
end
