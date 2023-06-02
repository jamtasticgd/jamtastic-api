module Teams
  class EnrollmentsController < ApplicationController
    contracts create: ::Teams::Enrollments::CreateContract, destroy: ::Teams::Enrollments::DestroyContract

    rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }
    rescue_from JoinTeam::AlreadyAMember do
      error_message = I18n.t('enrollments.errors.already_a_member')

      render(json: ErrorSerializer.render(error_message), status: :unprocessable_entity)
    end

    before_action :authenticate_user!

    def create
      team = Team.find(contract_result[:team_id])
      team_member = JoinTeam.new(user: current_user, team: team).call

      if team_member.persisted?
        render(json: EnrollmentsSerializer.render(team_member), status: :created)
      else
        render(json: Models::ErrorsSerializer.render(team_member), status: :unprocessable_entity)
      end
    end

    def destroy
      team = current_user.teams.find(contract_result[:team_id])
      team_member = team.team_members.find(contract_result[:id])
      team_member.destroy!

      head :no_content
    end
  end
end
