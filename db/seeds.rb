DEFAULT_EMAIL = 'test@test.com'
DEFAULT_PASSWORD = 'pleaseChangeMe!!1'

user = User.find_by_email(DEFAULT_EMAIL)
if user.blank?
  user = User.create(email: DEFAULT_EMAIL, password: DEFAULT_PASSWORD, password_confirmation: DEFAULT_PASSWORD)
end

sensor = Sensor.find_or_create_by(user: user, name: 'Test Sensor', sensor_type: 'BME280', access_token: 'test_access_token')
if sensor.sensor_data.count == 0
  100.times do |i|
    sensor.sensor_data.create(value: rand(100), value_type: 'temperature')
  end
end
