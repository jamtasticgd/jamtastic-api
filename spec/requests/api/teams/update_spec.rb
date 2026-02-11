# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update a team' do
  context 'when the authorization info is informed' do
    let(:team) { create(:team, :with_admin) }
    let(:authentication_headers) do
      user = team.owner
      params = {
        email: user.email,
        password: '123456'
      }
      post(user_session_path, params:)

      {
        uid: response.headers['uid'],
        client: response.headers['client'],
        'access-token': response.headers['access-token']
      }
    end

    context 'and the params are informed' do
      it 'returns an ok status code' do
        params = {
          id: team.id,
          name: 'Happy Madison Productions',
          description: 'We are a team making great games and movies.',
          approve_new_members: false,
          needed_skills: []
        }

        put team_path(team), params:, headers: authentication_headers

        expect(response).to have_http_status(:ok)
      end

      it 'returns the created team data' do
        params = {
          id: team.id,
          name: 'Happy Madison Productions',
          description: 'We are a team making great games and movies.',
          approve_new_members: false,
          needed_skills: []
        }

        put team_path(team), params:, headers: authentication_headers

        expect(response.parsed_body).to include(
          'name' => 'Happy Madison Productions',
          'approve_new_members' => false,
          'description' => 'We are a team making great games and movies.'
        )
      end
    end

    context 'and the params are not informed' do
      it 'returns an unprocessable entity status code' do
        put team_path(team), params: { id: team.id }, headers: authentication_headers

        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'returns the error message' do
        put team_path(team), params: { id: team.id }, headers: authentication_headers

        expect(response.parsed_body).to match(
          'errors' => [
            { 'detail' => 'não foi informado(a)', 'field' => 'name' },
            { 'detail' => 'não foi informado(a)', 'field' => 'description' },
            { 'detail' => 'não foi informado(a)', 'field' => 'approve_new_members' }
          ]
        )
      end
    end
  end

  context 'when the authorization info is not informed' do
    let(:team) { create(:team) }

    it 'returns an unauthorized error' do
      params = {
        id: team.id,
        name: 'Happy Madison Productions',
        description: 'We are a team making great games and movies.',
        approve_new_members: false,
        needed_skills: []
      }

      put(team_path(team), params:)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the error message' do
      params = {
        id: team.id,
        name: 'Happy Madison Productions',
        description: 'We are a team making great games and movies.',
        approve_new_members: false,
        needed_skills: []
      }

      put(team_path(team), params:)

      expect(response.parsed_body).to include(
        {
          'errors' => ['Para continuar, faça login ou registre-se.']
        }
      )
    end
  end
end
