class Sensor::NewDataHandler
  def initialize(device, sensor_measurements)
    @device = device
    @sensor_measurements = sensor_measurements
  end

  def save!
    created_sensor_measurements = []
    SensorMeasurement.transaction do
      @sensor_measurements.each do |sensor_type, value|
        begin
          created_sensor_measurements << @device.sensors.find_by!(sensor_type: sensor_type).sensor_measurements.create!(value: value)
        rescue ActiveRecord::RecordNotFound
          @device.api_errors.create!(error_message: I18n.t('errors.api_error.sensor_not_found', sensor_type: sensor_type))
        end
      end
    end

    created_sensor_measurements.each { |sensor_measurement| broadcast_new_sensor_measurement(sensor_measurement) }
    return created_sensor_measurements
  end

  private
  def broadcast_new_sensor_measurement(sensor_measurement)
    Broadcast::add_sensor_measurement_to_chart("sensor-show-page", sensor_measurement)
    Broadcast::add_sensor_measurement_to_chart("dashboard", sensor_measurement)
  end
end
