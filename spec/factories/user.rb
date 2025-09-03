FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { '123456' }
    uid { email }

    trait :confirmed do
      confirmed_at { 1.day.ago }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end

    # Specific users that match fixture data
    factory :confirmed_user do
      email { 'confirmed@jamtastic.org' }
      name { 'Confirmed user' }
      uid { 'confirmed@jamtastic.org' }
      confirmed_at { 1.day.ago }
    end

    factory :unconfirmed_user do
      email { 'unconfirmed@jamtastic.org' }
      name { 'Unconfirmed user' }
      uid { 'unconfirmed@jamtastic.org' }
      confirmed_at { nil }
    end
  end
end
