FactoryBot.define do
  factory :sensor_measurement do
    association :sensor
    value { 9.99 }
  end
end
