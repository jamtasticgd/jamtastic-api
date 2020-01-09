# frozen_string_literal: true

module Api
  class CompaniesController < ApplicationController
    # TODO: Add JWT authentication
    skip_before_action :verify_authenticity_token, only: :update

    def create
      company = Company.new(permitted_params)

      if company.save
        head :ok
      else
        render(json: { errors: company.errors }, status: :unprocessable_entity)
      end
    end

    private

    def permitted_params
      params.permit([
        :name,
        :email,
        :facebook,
        :twitter,
        :url,
        :logo
      ])
    end
  end
end
