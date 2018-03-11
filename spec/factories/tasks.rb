FactoryBot.define do
  factory :task do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
    expires_at { Time.current }
    user
  end
end
