# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Companies', type: :request do
  describe 'create a new company' do
    context 'when the given company does not exist' do
      context 'and all correct params are given' do
        it 'creates a company' do
          params = {
            name: 'Some company',
            email: 'email@somecompany.com'
          }

          post api_companies_path, params: params

          expect(response).to have_http_status(:ok)

          company = Company.find_by(
            name: 'Some company'
          )

          expect(company).to be_present
        end
      end

      context 'and the name is not informed' do
        it 'returns an unprocessable entity error' do
          params = {
            name: nil,
            email: 'email@somecompany.com'
          }

          post api_companies_path, params: params

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  context 'when the given company does exist' do
    it 'returns an unprocessable entity error' do
      Company.create!(name: 'Some company')

      params = {
        name: 'Some company',
        email: 'email@somecompany.com'
      }

      post api_companies_path, params: params

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
