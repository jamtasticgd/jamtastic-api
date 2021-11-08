class KnownSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :user, :skill, presence: true

  delegate :code, to: :skill, prefix: true
end
