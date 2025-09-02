# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'View a team' do
  context 'when the team exist' do
    it 'returns an ok status' do
      team = teams(:team_with_moderation)

      get team_path(team)

      expect(response).to have_http_status(:ok)
    end

    it 'returns the team name' do
      team = teams(:team_with_moderation)

      get team_path(team)

      expect(response.parsed_body).to include(
        'name' => 'Happy Madison Productions'
      )
    end

    it 'returns the team description' do
      team = teams(:team_with_moderation)

      get team_path(team)

      expect(response.parsed_body).to include(
        'description' => 'We are a team making great games and movies.'
      )
    end

    it 'returns the team creation date' do
      team = teams(:team_with_moderation)

      get team_path(team)

      expect(response.parsed_body).to include('created_at')
    end

    it 'returns the team update date' do
      team = teams(:team_with_moderation)

      get team_path(team)

      expect(response.parsed_body).to include('updated_at')
    end

    it 'returns the team needed skills' do
      team = teams(:team_with_moderation)

      get team_path(team)

      expect(response.parsed_body).to include(
        'needed_skills' => []
      )
    end

    it 'returns the team owner name' do
      team = teams(:team_with_moderation)

      get team_path(team)

      expect(response.parsed_body['members']).to include(
        'kind' => 'admin',
        'user' => {
          'name' => 'Confirmed user'
        }
      )
    end

    context 'and the user is owner of the team' do
      let(:headers) do
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

      it 'returns the list of members with id' do
        team = teams(:team_with_moderation)

        get(team_path(team), headers:)

        expect(response.parsed_body['members']).to include(
          a_hash_including(
            'id' => '6d061e04-65d2-5cf6-8ef6-640dfcdec045'
          )
        )
      end

      it 'returns the list of pending members with id' do
        team = teams(:team_with_moderation)

        get(team_path(team), headers:)

        expect(response.parsed_body['pending_members']).to include(
          a_hash_including(
            'id' => 'f3bfcf2c-5809-5be1-9203-dfd224fd8e88'
          )
        )
      end
    end

    context 'but the user is not owner of the team' do
      let(:headers) do
        params = {
          email: 'unconfirmed@jamtastic.org',
          password: '123456'
        }
        post(user_session_path, params:)

        {
          uid: response.headers['uid'],
          client: response.headers['client'],
          'access-token': response.headers['access-token']
        }
      end

      context 'and the user is member of the team' do
        it 'retuns the user enrollment id' do
          params = {
            email: 'zohan.dvir@jamtastic.org',
            password: '123456'
          }
          post(user_session_path, params:)

          headers = {
            uid: response.headers['uid'],
            client: response.headers['client'],
            'access-token': response.headers['access-token']
          }

          team = teams(:team_with_moderation)

          get(team_path(team), headers:)

          expect(response.parsed_body).to include(
            'enrollment_id' => '6d061e04-65d2-5cf6-8ef6-640dfcdec045'
          )
        end
      end

      context 'and the user is not a member of the team' do
        it 'does not return the enrollment id' do
          team = teams(:team_with_moderation)

          get(team_path(team), headers:)

          expect(response.parsed_body).not_to include('enrollment_id')
        end
      end

      it 'returns the list of members without id' do
        team = teams(:team_with_moderation)

        get(team_path(team), headers:)

        expect(response.parsed_body['members']).not_to include(
          a_hash_including(
            'id'
          )
        )
      end

      it 'does not return the list of pending members' do
        team = teams(:team_with_moderation)

        get(team_path(team), headers:)

        expect(response.parsed_body).not_to include('pending_members')
      end
    end
  end

  context 'when the team does not exist' do
    it 'returns a not found error' do
      get team_path('unknown_team_id')

      expect(response).to have_http_status(:not_found)
    end
  end
end
