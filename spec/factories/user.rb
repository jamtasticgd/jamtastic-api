FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { '123456' }
    uid { email }

    trait :with_itchio do
      itchio_id { Faker::Number.number(digits: 5).to_s }
      itchio_username { Faker::Internet.username }
      itchio_access_token { SecureRandom.hex(32) }
    end
  end
end
