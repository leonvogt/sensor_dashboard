class SensorDataHandler
  def initialize(device, sensor_value_params)
    @device = device
    @sensor_value_params = sensor_value_params
  end

  def save!
    created_sensor_data = []
    SensorData.transaction do
      @sensor_value_params.each do |sensor_type, value|
        begin
          created_sensor_data << @device.sensors.find_by!(sensor_type: sensor_type).sensor_data.create!(value: value)
        rescue ActiveRecord::RecordNotFound
          @device.api_errors.create!(error_message: I18n.t('errors.api_error.sensor_not_found', sensor_type: sensor_type))
        end
      end
    end

    created_sensor_data.each { |sensor_data| broadcast_new_sensor_data(sensor_data) }
    return created_sensor_data
  end

  private
  def broadcast_new_sensor_data(sensor_data)
    Broadcast::add_sensor_data_to_chart("sensor-show-page", sensor_data)
    Broadcast::add_sensor_data_to_chart("dashboard", sensor_data)
  end
end
