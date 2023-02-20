class SerializeSensorData
  def initialize(sensor, sensor_data)
    @sensor = sensor
    @sensor_data = sensor_data
  end

  def serialize(with_avg: :avg_of_each_hour)
    case with_avg
    when :avg_of_each_hour
      sensor_data = avg_of_each_hour
    end
    {
      chart_type:   @sensor.chart_type,
      value_suffix: SensorConfiguration::SENSOR_TYPE_SUFFIX[@sensor.sensor_type],
      min_value:    sensor_data.map { |data| data[:value] }.min,
      max_value:    sensor_data.map { |data| data[:value] }.max,
      avg_value:    sensor_data.map { |data| data[:value] }.sum || 1 / @sensor_data.count.round(2) || 1,
      timestamps:   sensor_data.map { |data| data[:timestamp] },
      values:       sensor_data.map { |data| data[:value] }
    }
  end

  def avg_of_each_hour
    sensor_data = @sensor_data.group_by { |data| data.created_at.beginning_of_hour }
    sensor_data = sensor_data.map do |key, value|
      {
        timestamp: key,
        value:     (value.map(&:value).sum / value.count).round(2)
      }
    end
  end
end
