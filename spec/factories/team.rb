FactoryBot.define do
  factory :team do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    approve_new_members { false }
    association :user, factory: :user

    trait :with_admin do
      after(:create) do |team|
        create(:team_member, :admin, team: team)
      end
    end

    trait :approve_new_members do
      approve_new_members { true }
    end
  end
end
