FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { Faker::Internet.password }
    uid { email }
  end
end
