FactoryBot.define do
  factory :sensor do
    sequence(:name)         { |n| "Test Sensor #{n}" }
    sequence(:access_token) { |n| "test_access_token#{n}" }
    description             { nil }
    sensor_type             { 'BME280' }
    association :user
  end
end
