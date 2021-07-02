# frozen_string_literal: true

module Api
  class TeamsController < Api::ApplicationController
    before_action :authenticate_user!

    def create
      contract_result = validate_params(Teams::CreateContract)

      if contract_result.success?
        team = CreateTeam.new(
          user: current_user,
          params: contract_result.to_h
        ).call

        if team.persisted?
          render(json: TeamsSerializer.render(team), status: :created)
        else
          render(json: Models::ErrorsSerializer.render(team), status: :unprocessable_entity)
        end
      else
        render(json: Contracts::ErrorsSerializer.render(contract_result), status: :unprocessable_entity)
      end
    end
  end
end
