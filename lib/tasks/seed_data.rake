DEFAULT_EMAIL = "test@test.com"
DEFAULT_PASSWORD = "pleaseChangeMe!!1"

namespace :seed_data do
  desc "Create sample data for guest user"
  task for_guest_user: :environment do
    user = User.find_by_email(User::GUEST_EMAIL)
    user = User.create!(email: User::GUEST_EMAIL, password: User::GUEST_PASSWORD, password_confirmation: User::GUEST_PASSWORD) if user.blank?

    seed_device(user, 3)
    user.devices.each { |device| seed_sensor(device, 3) }
    user.sensors.each { |sensor| seed_sensor_measurements(sensor, 100) }
    user.sensors.each { |sensor| seed_alarm_rules(sensor) }
    user.alarm_rules.each { |alarm_rule| seed_rule_violations(alarm_rule, 1) }
    user.rule_violations.each { |rule_violation| seed_notifications(user, rule_violation, 1) }
  end

  desc "Create sample data development"
  task for_initial_use: :environment do
    user = User.find_by_email(DEFAULT_EMAIL)
    user = User.create!(email: DEFAULT_EMAIL, password: DEFAULT_PASSWORD, password_confirmation: DEFAULT_PASSWORD) if user.blank?

    seed_device(user, 2)
    user.devices.each { |device| seed_sensor(device, 3) }
    user.sensors.each { |sensor| seed_sensor_measurements(sensor, 100) }
  end

  def seed_device(user, amount = 1)
    amount.times do
      Device.create!(name: Faker::House.room.capitalize, description: Faker::Lorem.paragraph, user: user)
    end
  end

  def seed_sensor(device, amount = 1)
    amount.times do
      Sensor.create!(sensor_type: Sensor::ConfigurationOptions::SENSOR_TYPES.sample, chart_type: "line", show_in_dashboard: true, device: device)
    end
  end

  def seed_sensor_measurements(sensor, amount = 1)
    value = 20
    amount.times do |i|
      value += rand(-2..2)
      SensorMeasurement.create!(value: value, sensor: sensor, created_at: Time.current - i.hours, updated_at: Time.current - i.hours)
    end
  end

  def seed_alarm_rules(sensor)
    AlarmRule.create!(rule_type: "max_value", value: 30, sensor: sensor)
    AlarmRule.create!(rule_type: "min_value", value: 0, sensor: sensor)
  end

  def seed_rule_violations(alarm_rule, amount = 1)
    amount.times do
      RuleViolation.create!(alarm_rule: alarm_rule, violation_text: I18n.t("rule_violations.violation_text", value: rand(50..80).to_s))
    end
  end

  def seed_notifications(user, rule_violation, amount = 1)
    amount.times do
      SensorAlarmNotification.with(rule_violation: rule_violation).deliver(user)
    end
  end
end
