class Sensor < ApplicationRecord
  belongs_to :device
  delegate :user, to: :device
  has_many :sensor_data, dependent: :destroy

  scope :shown_in_dashboard, -> { where(show_in_dashboard: true) }

  validates :sensor_type, :chart_type, :device, presence: true

  def to_s
    I18n.t(sensor_type, scope: 'sensors.sensor_types')
  end
end
