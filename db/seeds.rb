DEFAULT_EMAIL = 'test@test.com'
DEFAULT_PASSWORD = 'pleaseChangeMe!!1'

user = User.find_by_email(DEFAULT_EMAIL)
if user.blank?
  user = User.create(email: DEFAULT_EMAIL, password: DEFAULT_PASSWORD, password_confirmation: DEFAULT_PASSWORD)
end

device = Device.find_or_create_by(user: user, name: 'Test Device', description: 'Test description', access_token: 'test_access_token')
sensor = Sensor.find_or_create_by(device: device, sensor_type: 'temperature', chart_type: 'line')

if sensor.sensor_data.count == 0
  value = 20
  100.times do |i|
    value += rand(-2..2)
    sensor.sensor_data.create!(value: value, created_at: Time.current - i.hours)
  end
end
