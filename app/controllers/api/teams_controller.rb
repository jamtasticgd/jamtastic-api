# frozen_string_literal: true

module Api
  class TeamsController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken

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
          render(json: Models::ErrorsSerializer.new(team), status: :unprocessable_entity)
        end
      else
        render(json: Contracts::ErrorsSerializer.new(contract_result), status: :unprocessable_entity)
      end
    end
  end
end
