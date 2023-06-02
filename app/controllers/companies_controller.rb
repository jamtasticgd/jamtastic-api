# frozen_string_literal: true

class CompaniesController < ApplicationController
  contracts create: Companies::CreateContract

  def create
    company = Company.new(contract_result.to_h)

    if company.save
      render(json: CompaniesSerializer.render(company), status: :created)
    else
      render(json: Models::ErrorsSerializer.render(company), status: :unprocessable_entity)
    end
  end
end
