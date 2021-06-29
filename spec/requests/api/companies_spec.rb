# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Companies', type: :request do
  describe 'create a new company' do
    context 'when the given company does not exist' do
      context 'and all correct params are given' do
        before do
          params = {
            name: 'Some company',
            email: 'email@somecompany.com'
          }

          post api_companies_path, params: params
        end

        it 'returns the created status' do
          expect(response).to have_http_status(:created)
        end

        it 'returns the created company' do
          expect(response.parsed_body).to include(
            'name' => 'Some company',
            'email' => 'email@somecompany.com'
          )
        end

        it 'creates a company' do
          company = Company.find_by(
            name: 'Some company'
          )

          expect(company).to be_present
        end
      end

      context 'and the name is not informed' do
        before do
          params = {
            name: nil,
            email: 'email@somecompany.com'
          }

          post api_companies_path, params: params
        end

        it 'returns an unprocessable entity error' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the error message' do
          expect(response.parsed_body).to include(
            'errors' => [{
              'detail' => 'não foi informado(a)',
              'field' => 'name'
            }]
          )
        end
      end
    end
  end

  context 'when the given company does exist' do
    before do
      Company.create!(name: 'Some company')

      params = {
        name: 'Some company',
        email: 'email@somecompany.com'
      }

      post api_companies_path, params: params
    end

    it 'returns an unprocessable entity error' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns the error message' do
      expect(response.parsed_body).to include(
        'errors' => [{
          'detail' => 'já está em uso',
          'field' => 'name'
        }]
      )
    end
  end
end
