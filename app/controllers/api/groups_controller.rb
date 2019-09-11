# frozen_string_literal: true

module Api
  class GroupsController < ApplicationController
    # TODO: Add JWT authentication
    skip_before_action :verify_authenticity_token, only: :update

    def update
      group = Group.find_by!(name: permitted_params[:id])
      group.update!(member_count: permitted_params[:member_count])

      render(body: nil, status: :ok)
    end

    private

    def permitted_params
      params.permit([:id, :member_count])
    end
  end
end
