# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Approve a team' do
  context 'when the authorization info is informed' do
    let(:authentication_headers) do
      params = {
        email: 'confirmed@jamtastic.org',
        password: '123456'
      }
      post(user_session_path, params:)

      {
        uid: response.headers['uid'],
        client: response.headers['client'],
        'access-token': response.headers['access-token']
      }
    end

    context 'and the team exist' do
      context 'and the enrollment exist' do
        context 'and the enrollment is pending' do
          it 'returns an ok status' do
            team = teams(:team_with_moderation)
            team_member = team_members(:pending_member)

            post team_enrollment_approvals_path(team, team_member), headers: authentication_headers

            expect(response).to have_http_status(:ok)
          end

          it 'returns an updated enrollment information' do
            team = teams(:team_with_moderation)
            team_member = team_members(:pending_member)

            post team_enrollment_approvals_path(team, team_member), headers: authentication_headers

            expect(response.parsed_body).to include(
              'team' => a_hash_including(
                'id' => team.id
              ),
              'user' => a_hash_including(
                'name' => 'Billy Madison'
              )
            )
          end
        end

        context 'but the enrollment is already accepted' do
          it 'returns an unprocessable entity error' do
            team = teams(:team_with_moderation)
            team_member = team_members(:approved_member)

            post team_enrollment_approvals_path(team, team_member), headers: authentication_headers

            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'returns the error message' do
            team = teams(:team_with_moderation)
            team_member = team_members(:approved_member)

            post team_enrollment_approvals_path(team, team_member), headers: authentication_headers

            expect(response.parsed_body).to match(
              {
                'errors' => ['Já está aprovado.']
              }
            )
          end
        end
      end

      context 'but the enrollment does not exist' do
        it 'returns a not found error' do
          team = teams(:team_with_moderation)

          post team_enrollment_approvals_path(team, 'team_member_id'), headers: authentication_headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'and the team does not exist' do
      it 'returns a not found error' do
        post team_enrollment_approvals_path('team_id', 'team_member_id'), headers: authentication_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'when the authorization info is not informed' do
    it 'returns an unauthorized error' do
      post team_enrollment_approvals_path('team_id', 'team_member_id')

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the error message' do
      post team_enrollment_approvals_path('team_id', 'team_member_id')

      expect(response.parsed_body).to match(
        {
          'errors' => ['Para continuar, faça login ou registre-se.']
        }
      )
    end
  end
end
