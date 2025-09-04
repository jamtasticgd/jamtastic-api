# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'View a team' do
  before do
    create(:confirmed_user)
    create(:unconfirmed_user)
    create(:zohan_dvir)
  end

  context 'when the team exist' do
    it 'returns an ok status' do
      team = create(:team_with_moderation)

      get team_path(team)

      expect(response).to have_http_status(:ok)
    end

    it 'returns the team name' do
      team = create(:team_with_moderation)

      get team_path(team)

      expect(response.parsed_body).to include(
        'name' => 'Happy Madison Productions'
      )
    end

    it 'returns the team description' do
      team = create(:team_with_moderation)

      get team_path(team)

      expect(response.parsed_body).to include(
        'description' => 'We are a team making great games and movies.'
      )
    end

    it 'returns the team creation date' do
      team = create(:team_with_moderation)

      get team_path(team)

      expect(response.parsed_body).to include('created_at')
    end

    it 'returns the team update date' do
      team = create(:team_with_moderation)

      get team_path(team)

      expect(response.parsed_body).to include('updated_at')
    end

    it 'returns the team needed skills' do
      team = create(:team_with_moderation)

      get team_path(team)

      expect(response.parsed_body).to include(
        'needed_skills' => []
      )
    end

    it 'returns the team owner name' do
      team = create(:team_with_moderation)

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

      it 'returns the list of members with id' do
        team = create(:team_with_moderation)

        get(team_path(team), headers:)

        expect(response.parsed_body['members']).to include(
          a_hash_including(
            'id' => team.team_members.first.id
          )
        )
      end

      it 'returns the list of pending members with id' do
        team = create(:team_with_moderation)
        # Add a pending member
        pending_user = create(:user, :unconfirmed)
        create(:team_member, team: team, user: pending_user, approved: false)

        get(team_path(team), headers:)

        expect(response.parsed_body['pending_members']).to include(
          a_hash_including(
            'id' => team.team_members.pending.first.id
          )
        )
      end
    end

    context 'but the user is not owner of the team' do
      let(:headers) do
        params = {
          email: 'unconfirmed-test@jamtastic.org',
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

          team = create(:team_with_moderation)
          # Create a team member for the authenticated user
          zohan_user = User.find_by(email: 'zohan.dvir@jamtastic.org')
          create(:team_member, team: team, user: zohan_user, approved: true)

          get(team_path(team), headers:)

          expect(response.parsed_body).to include(
            'enrollment_id' => team.team_members.find_by(user: zohan_user).id
          )
        end
      end

      context 'and the user is not a member of the team' do
        it 'does not return the enrollment id' do
          team = create(:team_with_moderation)

          get(team_path(team), headers:)

          expect(response.parsed_body).not_to include('enrollment_id')
        end
      end

      it 'returns the list of members without id' do
        team = create(:team_with_moderation)

        get(team_path(team), headers:)

        expect(response.parsed_body['members']).not_to include(
          a_hash_including(
            'id'
          )
        )
      end

      it 'does not return the list of pending members' do
        team = create(:team_with_moderation)

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
