# frozen_string_literal: true

class Skill < ApplicationRecord
  validates :code, presence: true
end
