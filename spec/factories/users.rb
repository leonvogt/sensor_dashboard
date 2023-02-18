FactoryBot.define do
  factory :user do
    sequence(:email)        { |n| "test@test#{n}.ch" }
    password                { 'password123' }
    password_confirmation   { 'password123' }
  end
end
