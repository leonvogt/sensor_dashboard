FactoryBot.define do
  factory :mobile_app_connection do
    association :user
    platform    { "android" }
    app_version { "0.1.0" }
    sequence(:notification_token) { |n| "SuperSecretToken#{n}" }
  end
end
