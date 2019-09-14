# frozen_string_literal: true

module Api
  class GroupsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }

    # TODO: Add JWT authentication
    skip_before_action :verify_authenticity_token, only: :update

    def update
      group = Group.find_by!(name: permitted_params[:id])

      if group.update(member_count: permitted_params[:member_count])
        head :ok
      else
        render(json: { errors: group.errors }, status: :unprocessable_entity)
      end
    end

    private

    def permitted_params
      params.permit([:id, :member_count])
    end
  end
end
