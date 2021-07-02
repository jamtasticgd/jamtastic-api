FactoryBot.define do
  factory :team do
    name { Faker::Lorem.sentence  }
    description { Faker::Lorem.sentence   }
    approve_new_members { false }

    user
  end
end
