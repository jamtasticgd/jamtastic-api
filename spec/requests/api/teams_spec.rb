# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Teams API', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }

  path '/teams' do
    get 'List all teams' do
      tags 'Teams'
      description 'Retrieve a list of all teams'
      produces 'application/json'

      response '200', 'Teams retrieved successfully' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   description: { type: :string },
                   approve_new_members: { type: :boolean },
                   created_at: { type: :string, format: :date_time },
                   updated_at: { type: :string, format: :date_time },
                   needed_skills: {
                     type: :array,
                     items: { type: :string }
                   },
                   members: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         user_id: { type: :integer },
                         status: { type: :string }
                       }
                     }
                   }
                 }
               }

        let!(:team1) { create(:team, name: 'Team Alpha') }
        let!(:team2) { create(:team, name: 'Team Beta') }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
          expect(data.length).to eq(2)
        end
      end
    end

    post 'Create a new team' do
      tags 'Teams'
      description 'Create a new team'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, description: 'Team name' },
          description: { type: :string, description: 'Team description' },
          approve_new_members: { type: :boolean, description: 'Whether new members need approval' },
          needed_skills: {
            type: :array,
            items: { type: :string },
            description: 'List of required skill codes'
          }
        },
        required: ['name']
      }

      response '201', 'Team created successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 description: { type: :string },
                 approve_new_members: { type: :boolean },
                 created_at: { type: :string, format: :date_time },
                 updated_at: { type: :string, format: :date_time },
                 needed_skills: {
                   type: :array,
                   items: { type: :string }
                 }
               }

        let(:team) do
          {
            name: 'New Team',
            description: 'A new team for testing',
            approve_new_members: true,
            needed_skills: ['ruby', 'javascript']
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('New Team')
          expect(data['description']).to eq('A new team for testing')
          expect(data['approve_new_members']).to be true
        end
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/error'

        let(:team) { { name: 'New Team' } }

        run_test!
      end

      response '422', 'Validation error' do
        schema '$ref' => '#/components/schemas/error'

        let(:team) { { name: '' } }

        run_test!
      end
    end
  end

  path '/teams/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Team ID'

    get 'Get team details' do
      tags 'Teams'
      description 'Retrieve details of a specific team'
      produces 'application/json'

      response '200', 'Team details retrieved successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 description: { type: :string },
                 approve_new_members: { type: :boolean },
                 created_at: { type: :string, format: :date_time },
                 updated_at: { type: :string, format: :date_time },
                 needed_skills: {
                   type: :array,
                   items: { type: :string }
                 },
                 members: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       user_id: { type: :integer },
                       status: { type: :string }
                     }
                   }
                 }
               }

        let(:team) { create(:team, name: 'Test Team') }
        let(:id) { team.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(team.id)
          expect(data['name']).to eq('Test Team')
        end
      end

      response '404', 'Team not found' do
        schema '$ref' => '#/components/schemas/error'

        let(:id) { 99999 }

        run_test!
      end
    end

    put 'Update team' do
      tags 'Teams'
      description 'Update an existing team'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, description: 'Team name' },
          description: { type: :string, description: 'Team description' },
          approve_new_members: { type: :boolean, description: 'Whether new members need approval' },
          needed_skills: {
            type: :array,
            items: { type: :string },
            description: 'List of required skill codes'
          }
        }
      }

      response '200', 'Team updated successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 description: { type: :string },
                 approve_new_members: { type: :boolean },
                 created_at: { type: :string, format: :date_time },
                 updated_at: { type: :string, format: :date_time },
                 needed_skills: {
                   type: :array,
                   items: { type: :string }
                 }
               }

        let(:existing_team) { create(:team, user: user, name: 'Original Name') }
        let(:id) { existing_team.id }
        let(:team) { { name: 'Updated Name', description: 'Updated description' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('Updated Name')
          expect(data['description']).to eq('Updated description')
        end
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/error'

        let(:existing_team) { create(:team) }
        let(:id) { existing_team.id }
        let(:team) { { name: 'Updated Name' } }

        run_test!
      end

      response '404', 'Team not found' do
        schema '$ref' => '#/components/schemas/error'

        let(:id) { 99999 }
        let(:team) { { name: 'Updated Name' } }

        run_test!
      end
    end

    delete 'Delete team' do
      tags 'Teams'
      description 'Delete a team'
      security [bearer_auth: []]

      response '204', 'Team deleted successfully' do
        let(:existing_team) { create(:team, user: user) }
        let(:id) { existing_team.id }

        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/error'

        let(:existing_team) { create(:team) }
        let(:id) { existing_team.id }

        run_test!
      end

      response '404', 'Team not found' do
        schema '$ref' => '#/components/schemas/error'

        let(:id) { 99999 }

        run_test!
      end
    end
  end
end
