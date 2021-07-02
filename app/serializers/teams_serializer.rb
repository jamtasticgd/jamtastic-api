class TeamsSerializer < Blueprinter::Base
  identifier :id

  fields :name, :description, :approve_new_members, :created_at, :updated_at

  field :needed_skills do |team|
    team.needed_skills.map(&:skill_code)
  end
end
