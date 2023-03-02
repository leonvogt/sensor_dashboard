class SerializeSensorData
  def initialize(sensor, sensor_data)
    @sensor = sensor
    @sensor_data = sensor_data
  end

  def serialize(with_avg: :avg_of_each_hour)
    {
      chart_type:   @sensor.chart_type,
      value_suffix: @sensor.value_suffix,
      min_value:    @sensor_data.map(&:value).min,
      max_value:    @sensor_data.map(&:value).max,
      avg_value:    @sensor_data.map(&:value).sum || 1 / @sensor_data.count.round(2) || 1,
      timestamps:   @sensor_data.map(&:created_at),
      values:       @sensor_data.map(&:value)
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
