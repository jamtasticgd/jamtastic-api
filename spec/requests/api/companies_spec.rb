# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Companies API', type: :request do
  path '/companies' do
    post 'Create a new company' do
      tags 'Companies'
      description 'Create a new company'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, description: 'Company name' },
          description: { type: :string, description: 'Company description' },
          website: { type: :string, description: 'Company website URL' },
          industry: { type: :string, description: 'Company industry' }
        },
        required: ['name']
      }

      response '201', 'Company created successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 description: { type: :string },
                 website: { type: :string },
                 industry: { type: :string },
                 created_at: { type: :string, format: :date_time },
                 updated_at: { type: :string, format: :date_time }
               }

        let(:company) do
          {
            name: 'New Company',
            description: 'A new company for testing',
            website: 'https://example.com',
            industry: 'Technology'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('New Company')
          expect(data['description']).to eq('A new company for testing')
          expect(data['website']).to eq('https://example.com')
          expect(data['industry']).to eq('Technology')
        end
      end

      response '422', 'Validation error' do
        schema '$ref' => '#/components/schemas/error'

        let(:company) { { name: '' } }

        run_test!
      end
    end
  end
end