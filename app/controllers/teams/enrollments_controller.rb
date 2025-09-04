module Teams
  class EnrollmentsController < ApplicationController
    contracts create: ::Teams::Enrollments::CreateContract, destroy: ::Teams::Enrollments::DestroyContract

    rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }

    before_action :authenticate_user!

    def create
      team = Team.find(contract_result[:team_id])
      team_member = JoinTeam.new(user: current_user, team:).call

      if team_member.persisted?
        render(json: EnrollmentsSerializer.render(team_member), status: :created)
      else
        render(json: Models::ErrorsSerializer.render(team_member), status: :unprocessable_content)
      end
    rescue JoinTeam::AlreadyAMember
      error_message = I18n.t('enrollments.errors.already_a_member')

      render(json: ErrorSerializer.render(error_message), status: :unprocessable_content)
    end

    def destroy
      RemoveEnrollment.new(
        user: current_user,
        team_id: contract_result[:team_id],
        team_member_id: contract_result[:id]
      ).call

      head :no_content
    rescue RemoveEnrollment::CantRemoveAdminError
      error_message = I18n.t('enrollments.errors.cant_remove_admin')

      render(json: ErrorSerializer.render(error_message), status: :unprocessable_content)
    rescue RemoveEnrollment::CantRemoveOthersError
      error_message = I18n.t('enrollments.errors.cant_remove_others')

      render(json: ErrorSerializer.render(error_message), status: :unprocessable_content)
    end
  end
end
