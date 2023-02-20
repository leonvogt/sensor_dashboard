FactoryBot.define do
  factory :device do
    association :user

    sequence(:name)         { |n| "Test Sensor #{n}" }
    sequence(:access_token) { |n| "test_access_token#{n}" }
    description             { nil }
  end
end
