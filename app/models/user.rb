class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User

  has_many :team_members
  has_many :teams, through: :team_members
  has_many :known_skills, dependent: :destroy

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :confirmable, :trackable
end
