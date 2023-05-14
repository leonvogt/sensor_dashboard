module Broadcast
  def self.add_sensor_measurement_to_chart(page, sensor_measurement)
    Turbo::StreamsChannel.broadcast_append_to(
      [page, sensor_measurement.sensor.device.user_id],
      target: "sensor-container-#{sensor_measurement.sensor_id}",
      partial: "sensors/new_data_notifier",
      locals: { sensor_measurement: sensor_measurement }
    )
  end
end
