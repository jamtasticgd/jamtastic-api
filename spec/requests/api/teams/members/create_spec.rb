# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Join a team', type: :request do
  context 'when the authorization info is informed' do
    let(:authentication_headers) do
      params = {
        email: 'confirmed@jamtastic.org',
        password: '123456'
      }
      post(api_user_session_path, params: params)

      {
        uid: response.headers['uid'],
        client: response.headers['client'],
        'access-token': response.headers['access-token']
      }
    end

    context 'and the team exists' do
      context 'and the user is not part of the team' do
        it 'returns a success' do
          team = create(:team)

          post api_team_members_path(team), headers: authentication_headers

          expect(response).to have_http_status(:created)
        end

        it 'returns the team member data' do
          team = create(:team)

          post api_team_members_path(team), headers: authentication_headers

          expect(response.parsed_body).to include(
            'team' => a_hash_including(
              'id' => team.id
            ),
            'user' => a_hash_including(
              'name' => 'Confirmed user'
            )
          )
        end
      end

      context 'and the user is already part of the team' do
        it 'returns an unprocessable entity error' do
          team = create(:team)
          post api_team_members_path(team), headers: authentication_headers

          post api_team_members_path(team), headers: authentication_headers

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the error message' do
          team = create(:team)
          post api_team_members_path(team), headers: authentication_headers

          post api_team_members_path(team), headers: authentication_headers

          expect(response.parsed_body).to match(
            {
              'errors' => ['Já faz parte desse time.']
            }
          )
        end
      end
    end

    context 'and the team does not exists' do
      it 'returns a not found error' do
        post api_team_members_path('inexistent_team_id'), headers: authentication_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'when the authorization info is not informed' do
    it 'returns an unauthorized error' do
      team = create(:team)

      post api_team_members_path(team)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the error message' do
      team = create(:team)

      post api_team_members_path(team)

      expect(response.parsed_body).to match(
        {
          'errors' => ['Para continuar, faça login ou registre-se.']
        }
      )
    end
  end
end
