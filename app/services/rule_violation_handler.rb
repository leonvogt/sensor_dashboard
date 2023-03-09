class RuleViolationHandler
  def initialize(device, sensor_data)
    @device      = device
    @sensor_data = sensor_data
    @sensors     = sensor_data.map(&:sensor).uniq
    @alarm_rules = AlarmRule.where(sensor: @sensors)
  end

  # Creates violation if sensor data violates an alarm rule
  # Updates a violation if it already exists
  def maybe_create_or_update_violation
    @alarm_rules.each do |alarm_rule|
      sensor_data_that_violates_alarm_rule(alarm_rule, @sensor_data).each do |sensor_data|
        violation_text  = I18n.t('rule_violations.violation_text', value: sensor_data.to_s, locale: @device.user.locale)

        open_violations = alarm_rule.rule_violations.open
        if open_violations.present?
          open_violations.update_all(violation_text: violation_text)
        else
          AlarmRule.transaction do
            # Create a new violation
            rule_violation = alarm_rule.rule_violations.create!(violation_text: violation_text)

            # Send Notification to user
            SensorAlarmNotification.with(rule_violation: rule_violation).deliver(@device.user)
          end
        end
      end
    end
  end

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
