class EnrollmentsSerializer < Blueprinter::Base
  identifier :id

  fields :created_at, :updated_at

  association :team, blueprint: TeamsSerializer
  association :user, blueprint: UsersSerializer

  view :summary_member do
    exclude :id
    exclude :created_at
    exclude :updated_at
    exclude :team
  end

  view :summary_owner do
    exclude :created_at
    exclude :updated_at
    exclude :team
  end
end
