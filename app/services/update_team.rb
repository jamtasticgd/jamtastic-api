class UpdateTeam
  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    team = Team.owned(user).find(params[:id])
    team.update(**params.except(:needed_skills, :id))
    build_needed_skills(team)
    team.save

    team
  end

  private

  attr_reader :user, :params

  def build_needed_skills(team)
    needed_skills_codes = params[:needed_skills] || []
    needed_skills = Skill.where(code: needed_skills_codes)

    team.needed_skills.delete_all
    needed_skills.each do |needed_skill|
      team.needed_skills.new(skill: needed_skill)
    end
  end
end
