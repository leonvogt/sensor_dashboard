class RuleViolationHandler
  def initialize(device, sensor_data)
    @device      = device
    @sensor_data = sensor_data
    @sensors     = sensor_data.map(&:sensor).uniq
    @alarm_rules = AlarmRule.where(sensor: @sensors)
  end

  def maybe_create_violation
    # Check if the sensor value is outside the allowed range
    # If it is, create a new rule violation
    # If there is already a rule violation for this sensor, update the rule violation
    return if @alarm_rules.empty?

    @alarm_rules.each do |alarm_rule|
      case alarm_rule.rule_type
      when 'max_value'
        sensor_data_which_violates = @sensor_data.select { |sensor_data| sensor_data.value > alarm_rule.value }
      when 'min_value'
        sensor_data_which_violates = @sensor_data.select { |sensor_data| sensor_data.value < alarm_rule.value }
      end

      sensor_data_which_violates.each do |sensor_data|
        violation_text  = I18n.t('rule_violations.violation_text', value: sensor_data.to_s, locale: @device.user.locale)
        open_violations = alarm_rule.rule_violations.open
        if open_violations.present?
          open_violations.update_all(violation_text: violation_text)
        else
          alarm_rule.rule_violations.create!(violation_text: violation_text)
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
end
