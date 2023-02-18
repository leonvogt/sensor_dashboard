# Speichert Sensor Daten aufgrund einer Uplink-Message und sendet Alarmierungen wenn nötig
# Saves sensor data based on an uplink message and sends notifications if necessary
class NewSensorDataJob < ApplicationJob
  queue_as :default

  def perform(raw_sensor_data, device_id)
    device = Device.find(id: device_id)

    begin
      # sensor_data = Sensor::BME280.save_data(raw_data, device)
      # Sensor::EventHandler.maybe_create_event_or_close_existing(sensor_data, device)
    rescue RuntimeError => exception
      # Rollbar.warning("NewSensorDataJob (UplinkMessage ID: #{uplink_message.id})-> #{exception}")
    end
  end
end
