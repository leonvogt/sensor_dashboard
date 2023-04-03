class RuleViolationHandler
  def initialize(device, sensor_data)
    @device      = device
    @sensor_data = sensor_data
    @sensors     = device.sensors.where(id: sensor_data.map(&:sensor_id).uniq)
  end

  # Creates violation if sensor data violates an alarm rule
  # Updates a violation if it already exists
  def maybe_create_or_update_violation
    AlarmRule.where(sensor: @sensors).each do |alarm_rule|
      sensor_data_that_violates_alarm_rule(alarm_rule, @sensor_data).each do |sensor_data|
        violation_text  = I18n.t('rule_violations.violation_text', value: sensor_data.to_s, locale: @device.user.locale)

        open_violations = alarm_rule.rule_violations.open
        if open_violations.present?
          open_violations.update_all(violation_text: violation_text)
          next
        end

        AlarmRule.transaction do
          rule_violation = alarm_rule.rule_violations.create!(violation_text: violation_text)

          # Send Notification to user
          SensorAlarmNotification.with(rule_violation: rule_violation).deliver(@device.user)
        end
      end
    end
  end

  # Closes a violation if the sensor data is no longer violating the alarm rule
  def maybe_close_violation
    @sensors.each do |sensor|
      sensor.rule_violations.open.each do |rule_violation|
        case rule_violation.alarm_rule.rule_type
        when 'max_value'
          rule_violation.close! if @sensor_data.select { |sensor_data| sensor_data.sensor == sensor }.map(&:value).max <= rule_violation.alarm_rule.value
        when 'min_value'
          rule_violation.close! if @sensor_data.select { |sensor_data| sensor_data.sensor == sensor }.map(&:value).min >= rule_violation.alarm_rule.value
        end
      end
    end
  end

  private
  def sensor_data_that_violates_alarm_rule(alarm_rule, sensor_data)
    case alarm_rule.rule_type
    when 'max_value'
      sensor_data.select { |sensor_data| sensor_data.value > alarm_rule.value }
    when 'min_value'
      sensor_data.select { |sensor_data| sensor_data.value < alarm_rule.value }
    end
  end
end
