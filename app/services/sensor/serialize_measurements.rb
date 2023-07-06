class Sensor::SerializeMeasurements
  def initialize(sensor, sensor_measurements)
    @sensor = sensor
    @sensor_measurements = sensor_measurements
  end

  def serialize(with_avg: :avg_of_each_hour)
    {
      chart_type: @sensor.chart_type,
      value_suffix: @sensor.value_suffix,
      min_value: @sensor_measurements.map(&:value).min,
      max_value: @sensor_measurements.map(&:value).max,
      avg_value: @sensor_measurements.map(&:value).sum || 1 / @sensor_measurements.count.round(2) || 1,
      alarm_rules: @sensor.alarm_rules.map { |rule| serialize_alarm_rule(rule) },
      timestamps: @sensor_measurements.map(&:created_at),
      values: @sensor_measurements.map(&:value)
    }
  end

  private

  def serialize_alarm_rule(rule)
    {
      value: rule.value,
      rule_type: rule.rule_type,
      label: I18n.t(rule.rule_type, scope: "alarm_rules.rule_types")
    }
  end

  def avg_of_each_hour
    grouped_sensor_measurements = @sensor_measurements.group_by { |data| data.created_at.beginning_of_hour }
    grouped_sensor_measurements.map do |key, value|
      {
        timestamp: key,
        value: (value.map(&:value).sum / value.count).round(2)
      }
    end
  end
end
