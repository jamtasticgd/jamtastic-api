class TeamMember < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :team_id, :user_id, presence: true

  validates :approved, inclusion: [true, false]

  scope :approved, -> { where(approved: true) }
  scope :pending, -> { where(approved: false) }
end
