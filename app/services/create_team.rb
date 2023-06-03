class CreateTeam
  delegate :errors, to: :team

  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    team = Team.new(**params.except(:needed_skills))
    build_needed_skills(team)
    team.team_members.build(approved: true, user: user, kind: TeamMember::ADMIN)
    team.save

    team
  end

  private

  attr_reader :user, :params

  def build_needed_skills(team)
    needed_skills_codes = params[:needed_skills] || []
    needed_skills = Skill.where(code: needed_skills_codes)

    needed_skills.each do |needed_skill|
      team.needed_skills.new(skill: needed_skill)
    end
  end
end
