# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Remove a member from the team' do
  context 'when the authorization info is informed' do
    let(:authentication_headers) do
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

    context 'when the enrollment is deleted' do
      it 'returns a no content status' do
        team = teams(:team_with_moderation)
        team_member = team.team_members.first

        delete team_enrollment_path(team, team_member), headers: authentication_headers

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when a record not found error is raised' do
      it 'returns a not found status' do
        remove_enrollment_service = instance_double(RemoveEnrollment)
        allow(remove_enrollment_service).to receive(:call).and_raise(ActiveRecord::RecordNotFound)
        allow(RemoveEnrollment).to receive(:new).and_return(remove_enrollment_service)
        team = teams(:team_with_moderation)
        team_member = team.team_members.first

        delete team_enrollment_path(team, team_member), headers: authentication_headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when a can not remove admin error is raised' do
      before do
        remove_enrollment_service = instance_double(RemoveEnrollment)
        allow(remove_enrollment_service).to receive(:call).and_raise(RemoveEnrollment::CantRemoveAdminError)
        allow(RemoveEnrollment).to receive(:new).and_return(remove_enrollment_service)
        team = teams(:team_with_moderation)
        team_member = team.team_members.first

        delete team_enrollment_path(team, team_member), headers: authentication_headers
      end

      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(response.parsed_body).to match(
          {
            'errors' => ['Não é possível remover adminstradores do time.']
          }
        )
      end
    end

    context 'when a can not remove others error is raised' do
      before do
        remove_enrollment_service = instance_double(RemoveEnrollment)
        allow(remove_enrollment_service).to receive(:call).and_raise(RemoveEnrollment::CantRemoveOthersError)
        allow(RemoveEnrollment).to receive(:new).and_return(remove_enrollment_service)
        team = teams(:team_with_moderation)
        team_member = team.team_members.first

        delete team_enrollment_path(team, team_member), headers: authentication_headers
      end

      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(response.parsed_body).to match(
          {
            'errors' => ['Não é possível remover outros do time.']
          }
        )
      end
    end
  end

  context 'when the authorization info is not informed' do
    it 'returns an unauthorized error' do
      delete team_enrollment_path('team_id', 'team_member_id')

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the error message' do
      delete team_enrollment_path('team_id', 'team_member_id')

      expect(response.parsed_body).to match(
        {
          'errors' => ['Para continuar, faça login ou registre-se.']
        }
      )
    end
  end
end
