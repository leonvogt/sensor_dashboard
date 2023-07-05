FactoryBot.define do
  factory :alarm_rule do
    association :sensor
    rule_type { "max_value" }
    value { 10 }
  end
end
