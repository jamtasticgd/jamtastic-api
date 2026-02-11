FactoryBot.define do
  factory :skill do
    code { Faker::Lorem.word }

    # Specific skills that match fixture data
    factory :art_skill do
      code { 'art' }
    end

    factory :audio_skill do
      code { 'audio' }
    end

    factory :code_skill do
      code { 'code' }
    end

    factory :game_design_skill do
      code { 'game_design' }
    end

    factory :writing_skill do
      code { 'writing' }
    end
  end
end
