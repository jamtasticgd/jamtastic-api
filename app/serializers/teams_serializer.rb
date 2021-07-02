class TeamsSerializer < Blueprinter::Base
  identifier :id

  fields :name, :description, :approve_new_members, :created_at, :updated_at
end
