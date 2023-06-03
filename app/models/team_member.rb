class TeamMember < ApplicationRecord
  ADMIN = 'admin'.freeze
  MEMBER = 'member'.freeze

  belongs_to :team
  belongs_to :user

  validates :approved, inclusion: [true, false]
  validates :kind, inclusion: [ADMIN, MEMBER]

  scope :approved, -> { where(approved: true) }
  scope :pending, -> { where(approved: false) }

  scope :members, -> { where(kind: MEMBER) }
  scope :admin, -> { where(kind: ADMIN) }
end
