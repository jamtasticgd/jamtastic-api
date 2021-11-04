module Teams
  module Enrollments
    class ApprovalsController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }
      rescue_from ApproveEnrollment::AlreadyApprovedError do
        error_message = I18n.t('approvals.errors.already_approved')

        render(json: ErrorSerializer.render(error_message), status: :unprocessable_entity)
      end

      before_action :authenticate_user!

      def create
        contract_result = validate_params(::Teams::Enrollments::Approvals::CreateContract)

        if contract_result.success?
          team = current_user.teams.find(contract_result[:team_id])
          team_member = team.team_members.find(contract_result[:enrollment_id])

          ApproveEnrollment.new(team_member).call

          render(json: EnrollmentsSerializer.render(team_member), status: :ok)
        else
          render(json: Contracts::ErrorsSerializer.render(contract_result), status: :unprocessable_entity)
        end
      end
    end
  end
end
