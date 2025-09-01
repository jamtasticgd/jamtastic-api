FactoryBot.define do
  factory :skill do
    code { Faker::ProgrammingLanguage.name.downcase.gsub(/\s+/, '_') }
  end
end
