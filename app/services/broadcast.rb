module Broadcast
  def self.add_sensor_data_to_chart(page, sensor_data)
    Turbo::StreamsChannel.broadcast_append_to(
      [page, sensor_data.sensor.device.user_id],
      target: "sensor-container-#{sensor_data.sensor_id}",
      partial: "sensors/new_data_notifier",
      locals: { sensor_data: sensor_data }
    )
  end
end
