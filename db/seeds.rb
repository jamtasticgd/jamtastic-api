# frozen_string_literal: true

# Insert the groups member count
Group.create_with(
  member_count: 326
).find_or_create_by(
  name: 'telegram'
)

# Insert the default companies
Company.create_with(
  email: 'hello@sometripleastudio.com',
  facebook: 'sometripleastudio',
  twitter: 'someaaastudio',
  url: 'https://sometripleastudio.com/'
).find_or_create_by(
  name: 'An awesome AAA studios'
)

Company.create_with(
  email: 'hello@indiegamestudio.com',
  facebook: 'indiegamestudio',
  twitter: 'indiegamestudio',
  url: 'http://indiegamestudio.com'
).find_or_create_by(
  name: 'An indie game studio'
)

BASIC_SKILLS = ['art', 'audio', 'code', 'game_design', 'writing']

BASIC_SKILLS.each do |skill|
  Skill.find_or_create_by(
    code: skill
  )
end
