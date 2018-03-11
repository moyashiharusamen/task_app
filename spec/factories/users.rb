FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "hogehoge" }
    password_confirmation { "hogehoge" }
  end
end
