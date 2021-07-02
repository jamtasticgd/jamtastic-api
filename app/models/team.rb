class Team < ApplicationRecord
  belongs_to :user
  has_many :needed_skills

  validates :name, :description, presence: true
  validates :approve_new_members, inclusion: [true, false]
end
