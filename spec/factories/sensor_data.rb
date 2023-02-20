FactoryBot.define do
  factory :sensor_data do
    association :sensor
    value { 9.99 }
  end
end
