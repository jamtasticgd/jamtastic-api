FactoryBot.define do
  factory :team do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    approve_new_members { false }

    user

    trait :approve_new_members do
      approve_new_members { true }
    end
  end
end
