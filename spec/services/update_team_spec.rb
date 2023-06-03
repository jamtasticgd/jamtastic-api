# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateTeam, type: :service do
  describe '#call' do
    context 'when a valid user is informed' do
      context 'and the team exists' do
        context 'and the params are valid' do
          it 'updates the team' do
            team = create(:team, :with_admin)
            user = team.users.first
            params = {
              id: team.id,
              name: 'My new team name',
              description: 'My new team description',
              approve_new_members: false,
              needed_skills: ['art']
            }

            updated_team = described_class.new(user: user, params: params).call

            expect(updated_team.valid?).to be(true)
          end
        end

        context 'and the params are invalid' do
          it 'does not update the team' do
            team = create(:team, :with_admin)
            user = team.users.first
            params = { id: team.id, name: nil }

            updated_team = described_class.new(user: user, params: params).call

            expect(updated_team.valid?).to be(false)
          end
        end
      end

      context 'and the team does not exist' do
        it 'raises a record not found error' do
          user = create(:user)
          params = { id: 'unknown_team_id' }

          expect {
            described_class.new(user: user, params: params).call
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
