class GroupsSerializer < Blueprinter::Base
  identifier :name

  fields :member_count, :created_at, :updated_at
end
