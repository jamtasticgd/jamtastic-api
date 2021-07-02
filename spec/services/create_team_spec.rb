# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateTeam, type: :service do
  context 'when a valid user is informed' do
    it 'creates a new team' do
      user = users(:confirmed_user)
      params = {
        name: 'Happy Madison Productions',
        description: 'We are a team making great games and movies.',
        approve_new_members: false,
        needed_skills: []
      }

      create_team = described_class.new(user: user, params: params)
      team = create_team.call

      expect(team).to be_persisted
    end

    context 'and the needed skills are informed' do
      context 'and they are all valid skills' do
        it 'creates needed skills for the team' do
          user = users(:confirmed_user)
          params = {
            name: 'Happy Madison Productions',
            description: 'We are a team making great games and movies.',
            approve_new_members: false,
            needed_skills: %w[art code]
          }

          create_team = described_class.new(user: user, params: params)
          team = create_team.call

          expect(team.needed_skills.size).to eq(2)
        end
      end

      context 'and there are some invalid skills' do
        it 'creates only the valid needed skills for the team' do
          user = users(:confirmed_user)
          params = {
            name: 'Happy Madison Productions',
            description: 'We are a team making great games and movies.',
            approve_new_members: false,
            needed_skills: %w[art invalid]
          }

          create_team = described_class.new(user: user, params: params)
          team = create_team.call

          expect(team.needed_skills.size).to eq(1)
        end
      end
    end

    context 'and the needed skills are not informed' do
      it 'does not create needed skills for the team' do
        user = users(:confirmed_user)
        params = {
          name: 'Happy Madison Productions',
          description: 'We are a team making great games and movies.',
          approve_new_members: false,
          needed_skills: []
        }

        create_team = described_class.new(user: user, params: params)
        team = create_team.call

        expect(team.needed_skills.size).to eq(0)
      end
    end
  end

  context 'when no user is informed' do
    it 'does not create a new team' do
      params = {
        name: 'Happy Madison Productions',
        description: 'We are a team making great games and movies.',
        approve_new_members: false,
        needed_skills: []
      }

      create_team = described_class.new(user: nil, params: params)
      team = create_team.call

      expect(team).not_to be_persisted
    end
  end
end
