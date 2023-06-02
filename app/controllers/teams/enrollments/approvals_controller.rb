module Teams
  module Enrollments
    class ApprovalsController < ApplicationController
      contracts create: ::Teams::Enrollments::Approvals::CreateContract

      rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }
      rescue_from ApproveEnrollment::AlreadyApprovedError do
        error_message = I18n.t('approvals.errors.already_approved')

        render(json: ErrorSerializer.render(error_message), status: :unprocessable_entity)
      end

      before_action :authenticate_user!

      def create
        team = current_user.teams.find(contract_result[:team_id])
        team_member = team.team_members.find(contract_result[:enrollment_id])

        ApproveEnrollment.new(team_member).call

        render(json: EnrollmentsSerializer.render(team_member), status: :ok)
      end
    end
  end
end
