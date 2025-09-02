class Team < ApplicationRecord
  has_many :needed_skills, dependent: :destroy
  has_many :team_members, dependent: :destroy
  has_many :users, through: :team_members

  validates :name, :description, presence: true
  validates :approve_new_members, inclusion: [true, false]

  delegate :id, to: :user, prefix: true

  scope :owned, ->(user) { joins(:team_members).where(team_members: { user:, kind: TeamMember::ADMIN }) }

  def owner?(other_user)
    owner.id == other_user&.id
  end

  def owner
    team_members.find_by(kind: TeamMember::ADMIN).user
  end
end
