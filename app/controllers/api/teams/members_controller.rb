module Api
  module Teams
    class MembersController < Api::ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }
      rescue_from JoinTeam::AlreadyAMember do
        render(json: ErrorSerializer.render(t('api.team_members.errors.already_a_member')), status: :unprocessable_entity)
      end

      before_action :authenticate_user!

      def create
        contract_result = validate_params(::Teams::Members::CreateContract)

        if contract_result.success?
          team = Team.find(contract_result[:team_id])

          team_member = JoinTeam.new(
            user: current_user,
            team: team
          ).call

          if team_member.persisted?
            render(json: TeamMembersSerializer.render(team_member), status: :created)
          else
            render(json: Models::ErrorsSerializer.render(team_member), status: :unprocessable_entity)
          end
        else
          render(json: Contracts::ErrorsSerializer.render(contract_result), status: :unprocessable_entity)
        end
      end
    end
  end
end
