class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User
  has_many :teams, dependent: :destroy
  has_many :known_skills, dependent: :destroy

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :confirmable, :trackable
end
