FactoryBot.define do
  factory :sensor do
    association :device
    sensor_type { 'temperature' }
    chart_type  { 'line' }
  end
end
