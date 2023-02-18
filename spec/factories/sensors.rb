FactoryBot.define do
  factory :sensor do
    association :user
    name          { 'Test Sensor' }
    description   { nil }
    sensor_type   { 'BME280' }
    access_token  { 'test_access_token' }
  end
end
