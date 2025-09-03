FactoryBot.define do
  factory :team_member do
    user
    team
    approved { false }
    kind { TeamMember::MEMBER }

    trait :admin do
      kind { TeamMember::ADMIN }
      approved { true }
    end

    trait :approved do
      approved { true }
    end

    # Specific members that match fixture data
    factory :pending_member do
      approved { false }
      kind { TeamMember::MEMBER }
    end

    factory :approved_member do
      approved { true }
      kind { TeamMember::MEMBER }
    end
  end
end
