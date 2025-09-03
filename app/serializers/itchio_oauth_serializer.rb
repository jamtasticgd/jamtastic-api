# frozen_string_literal: true

class ItchioOauthSerializer < Blueprinter::Base
  identifier :id

  fields :email, :name, :itchio_username

  field :itchio_linked do |user|
    user.itchio_id.present?
  end

  field :created_at do |user|
    user.created_at.iso8601
  end

  field :updated_at do |user|
    user.updated_at.iso8601
  end
end
