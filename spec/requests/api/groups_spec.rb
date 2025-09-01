# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Groups API', type: :request do
  path '/groups/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Group name'

    put 'Update group' do
      tags 'Groups'
      description 'Update an existing group'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :group, in: :body, schema: {
        type: :object,
        properties: {
          member_count: { type: :integer, description: 'Number of members in the group' }
        },
        required: ['member_count']
      }

      response '200', 'Group updated successfully' do
        schema type: :object,
               properties: {
                 id: { type: :string },
                 name: { type: :string },
                 member_count: { type: :integer },
                 created_at: { type: :string, format: :date_time },
                 updated_at: { type: :string, format: :date_time }
               }

        let(:existing_group) { create(:group, name: 'test-group') }
        let(:id) { existing_group.name }
        let(:group) { { member_count: 10 } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['member_count']).to eq(10)
        end
      end

      response '404', 'Group not found' do
        schema '$ref' => '#/components/schemas/error'

        let(:id) { 'non-existent-group' }
        let(:group) { { member_count: 10 } }

        run_test!
      end

      response '422', 'Validation error' do
        schema '$ref' => '#/components/schemas/error'

        let(:existing_group) { create(:group, name: 'test-group') }
        let(:id) { existing_group.name }
        let(:group) { { member_count: -1 } }

        run_test!
      end
    end
  end
end