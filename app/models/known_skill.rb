class KnownSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  delegate :code, to: :skill, prefix: true
end
