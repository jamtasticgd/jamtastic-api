# frozen_string_literal: true

class Group < ApplicationRecord
  validates :name, :member_count, presence: true
end
