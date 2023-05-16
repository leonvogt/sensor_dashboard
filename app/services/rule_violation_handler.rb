class RuleViolationHandler
  def initialize(measurements)
    @measurements = measurements
    @user = measurements.first&.sensor&.user
  end

  def check_for_violations!
    alarm_rules = AlarmRule.where(sensor: @measurements.map(&:sensor))
    return if alarm_rules.blank?

    @measurements.each do |measurement|
      measurement.alarm_rules.each do |alarm_rule|
        if measurement_violates_rule?(measurement, alarm_rule)
          create_or_update_violation(measurement, alarm_rule)
        else
          alarm_rule.rule_violations.open.map(&:close!)
        end
      end
    end
  end

  private

  def create_or_update_violation(measurement, alarm_rule)
    # Update open violations
    violation_text = I18n.t('rule_violations.violation_text', value: measurement.to_s, locale: @user.locale)
    open_violations = alarm_rule.rule_violations.open
    if open_violations.present?
      open_violations.update_all(violation_text: violation_text)
      return
    end

    # Create new violation
    AlarmRule.transaction do
      rule_violation = alarm_rule.rule_violations.create!(violation_text: violation_text)
      SensorAlarmNotification.with(rule_violation: rule_violation).deliver(@user)
    end
  end

  def measurement_violates_rule?(measurement, rule)
    rule.rule_type == 'max_value' ? measurement.value > rule.value : measurement.value < rule.value
  end
end
