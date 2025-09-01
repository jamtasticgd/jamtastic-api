FactoryBot.define do
  factory :group do
    name { Faker::Lorem.word }
    member_count { Faker::Number.between(from: 1, to: 100) }
  end
end
