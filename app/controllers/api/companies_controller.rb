# frozen_string_literal: true

module Api
  class CompaniesController < Api::ApplicationController
    def create
      contract_result = validate_params(Companies::CreateContract)

      if contract_result.success?
        company = Company.new(contract_result.to_h)

        if company.save
          render(json: CompaniesSerializer.render(company), status: :created)
        else
          render(json: Models::ErrorsSerializer.new(company), status: :unprocessable_entity)
        end
      else
        render(json: Contracts::ErrorsSerializer.new(contract_result), status: :unprocessable_entity)
      end
    end
  end
end
