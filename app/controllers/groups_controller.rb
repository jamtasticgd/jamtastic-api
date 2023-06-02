# frozen_string_literal: true

class GroupsController < ApplicationController
  contracts update: Groups::UpdateContract

  def update
    group = Group.find_by!(name: contract_result[:id])

    if group.update(member_count: contract_result[:member_count])
      render(json: GroupsSerializer.render(group), status: :ok)
    else
      render(json: Models::ErrorsSerializer.render(group), status: :unprocessable_entity)
    end
  end
end
