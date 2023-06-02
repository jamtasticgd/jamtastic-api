# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Delete a team' do
  context 'when the authorization info is informed' do
    let(:headers) do
      params = {
        email: 'confirmed@jamtastic.org',
        password: '123456'
      }
      post(user_session_path, params: params)

      {
        uid: response.headers['uid'],
        client: response.headers['client'],
        'access-token': response.headers['access-token']
      }
    end

    context 'and the team exists' do
      context 'and the user is the owner of the team' do
        it 'returns a no content status' do
          team = teams(:team_with_moderation)

          delete team_path(team), headers: headers

          expect(response).to have_http_status(:no_content)
        end
      end

      context 'but the user is not the owner of the team' do
        it 'returns a not found error' do
          team = teams(:team_with_moderation)

          params = {
            email: 'billy.madison@jamtastic.org',
            password: '123456'
          }
          post(user_session_path, params: params)

          headers = {
            uid: response.headers['uid'],
            client: response.headers['client'],
            'access-token': response.headers['access-token']
          }

          delete team_path(team), headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'but the team does not exist' do
      it 'returns a not found error' do
        delete team_path('unknown_team_id'), headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'when the authorization info is not informed' do
    it 'returns an unauthorized error' do
      team = teams(:team_with_moderation)

      delete team_path(team)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the error message' do
      team = teams(:team_with_moderation)

      delete team_path(team)

      expect(response.parsed_body).to include(
        {
          'errors' => ['Para continuar, faça login ou registre-se.']
        }
      )
    end
  end
end
