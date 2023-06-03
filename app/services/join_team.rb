class JoinTeam
  class AlreadyAMember < StandardError; end

  def initialize(user:, team:)
    raise ArgumentError if user.blank? || team.blank?

    @user = user
    @team = team
  end

  def call
    raise AlreadyAMember if already_a_member?

    approved = !team.approve_new_members

    TeamMember.create(approved: approved, team: team, user: user, kind: TeamMember::MEMBER)
  end

  private

  attr_reader :team, :user

  def already_a_member?
    team_members = team.team_members.map(&:user_id)

    team_members.find { |member_user_id| member_user_id == user.id }
  end
end
