# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team do
  describe '#owner' do
    it 'returns the user of the owner of the team' do
      user = create(:user)
      team = create(:team)
      create(:team_member, :admin, team:, user:)

      team_owner_user = team.owner

      expect(team_owner_user).to eq(user)
    end
  end

  describe '#owner?' do
    context 'when the user is the owner of the team' do
      it 'returns true' do
        user = create(:user)
        team = create(:team)
        create(:team_member, :admin, team:, user:)

        expect(team.owner?(user)).to be(true)
      end
    end

    context 'when the user is not the owner of the team' do
      it 'returns false' do
        user = create(:user)
        team = create(:team, :with_admin)

        expect(team.owner?(user)).to be(false)
      end
    end
  end
end
