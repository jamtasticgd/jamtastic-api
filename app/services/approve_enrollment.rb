class ApproveEnrollment
  class AlreadyApprovedError < StandardError; end

  def initialize(team_member)
    raise ArgumentError if team_member.blank?

    @team_member = team_member
  end

  def call
    raise AlreadyApprovedError if team_member.approved?

    team_member.update(approved: true)

    team_member
  end

  private

  attr_reader :team_member
end
