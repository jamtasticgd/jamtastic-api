class NeededSkill < ApplicationRecord
  belongs_to :team
  belongs_to :skill

  delegate :code, to: :skill, prefix: true
end
