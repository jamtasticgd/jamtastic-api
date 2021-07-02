class NeededSkill < ApplicationRecord
  belongs_to :team
  belongs_to :skill

  validates :team, :skill, presence: true
end
