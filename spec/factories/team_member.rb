FactoryBot.define do
  factory :team_member do
    user
    team
    approved { false }
    kind { TeamMember::MEMBER }

    trait :admin do
      kind { TeamMember::ADMIN }
    end

    trait :approved do
      approved { true }
    end
  end
end
