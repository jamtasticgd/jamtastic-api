# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create a team' do
  before do
    create(:confirmed_user)
  end

  context 'when the authorization info is informed' do
    let(:authentication_headers) do
      params = {
        email: 'confirmed-test@jamtastic.org',
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
      it 'returns an created status code' do
        params = {
          name: 'Happy Madison Productions',
          description: 'We are a team making great games and movies.',
          approve_new_members: false,
          needed_skills: []
        }

        post teams_path, params:, headers: authentication_headers

        expect(response).to have_http_status(:created)
      end

      it 'returns the created team data' do
        params = {
          name: 'Happy Madison Productions',
          description: 'We are a team making great games and movies.',
          approve_new_members: false,
          needed_skills: []
        }

        post teams_path, params:, headers: authentication_headers

        expect(response.parsed_body).to include(
          'name' => 'Happy Madison Productions',
          'approve_new_members' => false,
          'description' => 'We are a team making great games and movies.'
        )
      end
    end

    context 'and the params are not informed' do
      it 'returns an unprocessable entity status code' do
        post teams_path, params: {}, headers: authentication_headers

        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'returns the error message' do
        post teams_path, params: {}, headers: authentication_headers

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
    it 'returns an unauthorized error' do
      params = {
        name: 'Happy Madison Productions',
        description: 'We are a team making great games and movies.',
        approve_new_members: false,
        needed_skills: []
      }

      post(teams_path, params:)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the error message' do
      params = {
        name: 'Happy Madison Productions',
        description: 'We are a team making great games and movies.',
        approve_new_members: false,
        needed_skills: []
      }

      post(teams_path, params:)

      expect(response.parsed_body).to include(
        {
          'errors' => ['Para continuar, faça login ou registre-se.']
        }
      )
    end
  end
end
