FactoryBot.define do
  factory :device do
    association :user

    sequence(:name)         { |n| "Test Sensor #{n}" }
    sequence(:access_token) { |n| "test_access_token#{n}" }
    description             { nil }

    trait :with_sensor do
      transient do
        sensor { create :sensor }
      end
      after(:create) do |device, evaluator|
        device.sensors.create! sensor_type: evaluator.sensor.sensor_type, chart_type: evaluator.sensor.chart_type
      end
    end
  end
end
