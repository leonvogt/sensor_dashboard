FactoryBot.define do
  factory :sensor do
    association :device
    sensor_type { 'temperature' }
  end
end
