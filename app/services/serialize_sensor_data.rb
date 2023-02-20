class SerializeSensorData
  def initialize(sensor, sensor_data)
    @sensor = sensor
    @sensor_data = sensor_data
  end

  def serialize
    {
      chart_type:   @sensor.chart_type,
      value_suffix: SensorConfiguration::SENSOR_TYPE_SUFFIX[@sensor.sensor_type],
      min_value:    @sensor_data.map(&:value).min,
      max_value:    @sensor_data.map(&:value).max,
      avg_value:    @sensor_data.map(&:value).sum || 1 / @sensor_data.count.round(2) || 1,
      timestamps:   @sensor_data.map(&:created_at),
      values:       @sensor_data.map(&:value)
    }
  end
end
