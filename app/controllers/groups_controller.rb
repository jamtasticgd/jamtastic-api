# frozen_string_literal: true

class GroupsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }

  def update
    contract_result = validate_params(Groups::UpdateContract)

    if contract_result.success?
      group = Group.find_by!(name: contract_result[:id])

      if group.update(member_count: contract_result[:member_count])
        render(json: GroupsSerializer.render(group), status: :ok)
      else
        render(json: Models::ErrorsSerializer.render(group), status: :unprocessable_entity)
      end
    else
      render(json: Contracts::ErrorsSerializer.render(contract_result), status: :unprocessable_entity)
    end
  end
end
