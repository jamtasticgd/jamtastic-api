class Team < ApplicationRecord
  belongs_to :user
  has_many :needed_skills, dependent: :destroy
  has_many :team_members, dependent: :destroy

  validates :name, :description, presence: true
  validates :approve_new_members, inclusion: [true, false]

  delegate :id, to: :user, prefix: true
end
