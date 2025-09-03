FactoryBot.define do
  factory :team do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    approve_new_members { false }

    trait :with_admin do
      after(:create) do |team|
        create(:team_member, :admin, team:)
      end
    end

    trait :approve_new_members do
      approve_new_members { true }
    end

    # Specific team that matches fixture data
    factory :team_with_moderation do
      name { 'Happy Madison Productions' }
      description { 'We are a team making great games and movies.' }
      approve_new_members { true }

      after(:create) do |team|
        user = User.find_or_create_by(email: 'confirmed@jamtastic.org') do |u|
          u.name = 'Confirmed user'
          u.password = '123456'
          u.uid = 'confirmed@jamtastic.org'
          u.confirmed_at = 1.day.ago
        end

        create(:team_member, :admin, team: team, user: user)
      end
    end
  end
end
