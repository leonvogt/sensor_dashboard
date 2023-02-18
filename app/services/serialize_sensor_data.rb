class SerializeSensorData
  def initialize(sensor, sensor_data)
    @sensor = sensor
    @sensor_data = sensor_data
  end

  def serialize
    possible_values = SensorTypes::SENSOR_VALUE_TYPES[@sensor.sensor_type]
    sensor_data     = @sensor_data.select { |data| possible_values.include?(data.value_type) }
    serializes_data = assamble_json(sensor_data)

    # fill in missing values for each value type
    possible_values.each do |value_type|
      serializes_data << {
        value_type: value_type,
        min_value: nil,
        max_value: nil,
        avg_value: nil,
        data: []
      } if serializes_data.none? { |data| data[:value_type] == value_type }
    end

    serializes_data
  end

  private
  def assamble_json(sensor_data)
    sensor_data.group_by(&:value_type).map do |value_type, data|
      {
        value_type: value_type,
        min_value: data.map(&:value).min,
        max_value: data.map(&:value).max,
        avg_value: (data.map(&:value).sum / data.count).round(2),
        timestamps: data.map { |data| data.created_at.to_i },
        values: data.map(&:value)
      }
    end
  end
end
