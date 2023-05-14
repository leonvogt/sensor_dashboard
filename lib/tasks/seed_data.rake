namespace :seed_data do
  desc 'Create sample data for guest user'
  task for_guest_user: :environment do
    user = User.find_by_email(User::GUEST_EMAIL)
    user = User.create!(email: User::GUEST_EMAIL, password: User::GUEST_PASSWORD, password_confirmation: User::GUEST_PASSWORD) if user.blank?

    seed_device(user, 3)
    user.devices.each { |device| seed_sensor(device, 3) }
    user.sensors.each { |sensor| seed_sensor_measurements(sensor, 100) }
  end

  desc 'Create sample data development'
  task for_initial_use: :environment do
    DEFAULT_EMAIL    = 'test@test.com'
    DEFAULT_PASSWORD = 'pleaseChangeMe!!1'
    user = User.find_by_email(DEFAULT_EMAIL)
    user = User.create!(email: DEFAULT_EMAIL, password: DEFAULT_PASSWORD, password_confirmation: DEFAULT_PASSWORD) if user.blank?

    seed_device(user, 2)
    user.devices.each { |device| seed_sensor(device, 3) }
    user.sensors.each { |sensor| seed_sensor_measurements(sensor, 100) }
  end

  def seed_device(user, amount = 1)
    amount.times do
      device = Device.create!(name: Faker::Mountain.name, description: Faker::Lorem.paragraph, user: user)
    end
  end

  def seed_sensor(device, amount = 1)
    amount.times do
      sensor = Sensor.create!(sensor_type: Sensor::ConfigurationOptions::SENSOR_TYPES.sample, chart_type: 'line', show_in_dashboard: true, device: device)
    end
  end

  def seed_sensor_measurements(sensor, amount = 1)
    value = 20
    amount.times do |i|
      value += rand(-2..2)
      SensorMeasurement.create!(value: value, sensor: sensor, created_at: Time.current - i.hours, updated_at: Time.current - i.hours)
    end
  end
end
