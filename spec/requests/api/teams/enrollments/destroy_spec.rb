# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Remove a member from the team', type: :request do
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
      context 'and the user is the owner' do
        context 'and the enrollment exist' do
          it 'deletes the enrollment' do
            team = teams(:team_with_moderation)
            team_member = team.team_members.first

            expect {
              delete api_team_enrollment_path(team, team_member), headers: authentication_headers
            }.to change(TeamMember, :count).by(-1)
          end

          it 'returns a no content status' do
            team = teams(:team_with_moderation)
            team_member = team.team_members.first

            delete api_team_enrollment_path(team, team_member), headers: authentication_headers

            expect(response).to have_http_status(:no_content)
          end
        end

        context 'and the enrollment does not exist' do
          it 'returns a not found error' do
            team = teams(:team_with_moderation)

            delete api_team_enrollment_path(team, 'team_member_id'), headers: authentication_headers

            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context 'and the user is not the owner' do
        it 'returns a not found error' do
          team = teams(:team_without_moderation)
          team_member = team.team_members.first

          delete api_team_enrollment_path(team, team_member), headers: authentication_headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'and the team does not exists' do
      it 'returns a not found error' do
        delete api_team_enrollment_path('team_id', 'team_member_id'), headers: authentication_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'when the authorization info is not informed' do
    it 'returns an unauthorized error' do
      delete api_team_enrollment_path('team_id', 'team_member_id')

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the error message' do
      delete api_team_enrollment_path('team_id', 'team_member_id')

      expect(response.parsed_body).to match(
        {
          'errors' => ['Para continuar, faça login ou registre-se.']
        }
      )
    end
  end
end
