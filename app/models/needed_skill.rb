class NeededSkill < ApplicationRecord
  belongs_to :team
  belongs_to :skill

  validates :team, :skill, presence: true

  delegate :code, to: :skill, prefix: true
end
