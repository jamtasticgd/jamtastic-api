FactoryBot.define do
  factory :group do
    name { Faker::Lorem.word }
    member_count { Faker::Number.between(from: 1, to: 1000) }

    # Specific group that matches fixture data
    factory :telegram_group do
      name { 'telegram' }
      member_count { 326 }
    end
  end
end
