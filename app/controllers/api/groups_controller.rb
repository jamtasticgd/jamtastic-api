# frozen_string_literal: true

module Api
  class GroupsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }

    # TODO: Add JWT authentication
    skip_before_action :verify_authenticity_token, only: :update

    def update
      contract_result = validate_params(Groups::UpdateContract)

      if contract_result.success?
        group = Group.find_by!(name: contract_result[:id])

        if group.update(member_count: contract_result[:member_count])
          head :ok
        else
          render(json: Models::ErrorsSerializer.new(company), status: :unprocessable_entity)
        end
      else
        render(json: Contracts::ErrorsSerializer.new(contract_result), status: :unprocessable_entity)
      end
    end
  end
end
