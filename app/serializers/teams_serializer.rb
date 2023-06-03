class TeamsSerializer < Blueprinter::Base
  identifier :id

  field :enrollment_id, if: ->(_, _, options) { options[:enrollment_id].present? } do |_, options|
    options[:enrollment_id]
  end

  fields :name, :description, :approve_new_members, :created_at, :updated_at

  field :needed_skills do |team|
    team.needed_skills.map(&:skill_code)
  end

  association :owner, blueprint: UsersSerializer

  association :members, blueprint: EnrollmentsSerializer, view: :summary_member do |team|
    team.team_members.members.approved
  end

  view :owner do
    association :members, blueprint: EnrollmentsSerializer, view: :summary_owner do |team|
      team.team_members.members.approved
    end

    association :pending_members, blueprint: EnrollmentsSerializer, view: :summary_owner do |team|
      team.team_members.members.pending
    end
  end
end
