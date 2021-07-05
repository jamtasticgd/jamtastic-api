class TeamsSerializer < Blueprinter::Base
  identifier :id

  fields :name, :description, :approve_new_members, :created_at, :updated_at

  field :needed_skills do |team|
    team.needed_skills.map(&:skill_code)
  end

  association :user, name: :owner, blueprint: UsersSerializer

  association :members, blueprint: UsersSerializer do |team|
    team.team_members.approved.map(&:user)
  end

  view :owner do
    association :pending_members, blueprint: UsersSerializer do |team|
      team.team_members.pending.map(&:user)
    end
  end
end
