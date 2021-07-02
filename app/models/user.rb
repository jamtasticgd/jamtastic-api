class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User
  has_many :teams

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable
end
