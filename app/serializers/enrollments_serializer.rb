class EnrollmentsSerializer < Blueprinter::Base
  identifier :id

  fields :created_at, :updated_at

  association :team, blueprint: TeamsSerializer
  association :user, blueprint: UsersSerializer
end
