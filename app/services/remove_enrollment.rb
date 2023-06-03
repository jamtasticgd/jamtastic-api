class RemoveEnrollment
  class CantRemoveAdminError < StandardError; end
  class CantRemoveOthersError < StandardError; end

  def initialize(user:, team_id:, team_member_id:)
    @user = user
    @team_id = team_id
    @team_member_id = team_member_id
  end

  def call
    team = user.teams.find(team_id)
    team_member = team.team_members.find(team_member_id)

    raise CantRemoveAdminError if team_member.admin?

    if team.owner?(user)
      remove_as_owner(team_member)
    else
      remove_as_member(team_member)
    end
  end

  private

  def remove_as_owner(team_member)
    team_member.destroy!
  end

  def remove_as_member(team_member)
    same_user = team_member.user_id == user.id

    raise CantRemoveOthersError unless same_user

    team_member.destroy!
  end

  attr_reader :user, :team_id, :team_member_id
end
