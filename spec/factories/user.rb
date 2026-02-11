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
      email { 'confirmed-test@jamtastic.org' }
      name { 'Confirmed user' }
      uid { 'confirmed-test@jamtastic.org' }
      confirmed_at { 1.day.ago }
    end

    factory :unconfirmed_user do
      email { 'unconfirmed-test@jamtastic.org' }
      name { 'Unconfirmed user' }
      uid { 'unconfirmed-test@jamtastic.org' }
      confirmed_at { nil }
    end

    factory :billy_madison do
      email { 'billy.madison@jamtastic.org' }
      name { 'Billy Madison' }
      uid { 'billy.madison@jamtastic.org' }
      confirmed_at { 1.day.ago }
    end

    factory :zohan_dvir do
      email { 'zohan.dvir@jamtastic.org' }
      name { 'Zohan Dvir' }
      uid { 'zohan.dvir@jamtastic.org' }
      confirmed_at { 1.day.ago }
    end
  end
end
