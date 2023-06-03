# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JoinTeam, type: :service do
  describe '#call' do
    context 'when an user is informed' do
      context 'and a team is informed' do
        context 'and the user is not a member of the team' do
          it 'adds the user to the team' do
            team = create(:team)
            user = create(:user)

            team_member = described_class.new(team: team, user: user).call

            expect(team_member).to be_persisted
          end

          context 'when the team owner need do approve new members' do
            it 'creates an unapproved team member' do
              team = create(:team, :approve_new_members)
              user = create(:user)

              team_member = described_class.new(team: team, user: user).call

              expect(team_member).not_to be_approved
            end
          end

          context 'when the team owner does not need do approve new members' do
            it 'creates an approved team member' do
              team = create(:team)
              user = create(:user)

              team_member = described_class.new(team: team, user: user).call

              expect(team_member).to be_approved
            end
          end
        end

        context 'but the user the team owner' do
          it 'raises an already a member error' do
            user = create(:user)
            team = create(:team)
            create(:team_member, :admin, team: team, user: user)

            expect {
              described_class.new(team: team, user: user).call
            }.to raise_error(JoinTeam::AlreadyAMember)
          end
        end

        context 'but the user is already a member of the team' do
          it 'raises an already a member error' do
            team = create(:team)
            user = create(:user)
            described_class.new(team: team, user: user).call

            expect {
              described_class.new(team: team.reload, user: user).call
            }.to raise_error(JoinTeam::AlreadyAMember)
          end
        end
      end

      context 'but the team is not informed' do
        it 'raises an ArgumentError' do
          user = create(:user)

          expect {
            described_class.new(team: nil, user: user).call
          }.to raise_error(ArgumentError)
        end
      end
    end

    context 'when an user is not informed' do
      it 'raises an ArgumentError' do
        team = create(:team)

        expect {
          described_class.new(team: team, user: nil).call
        }.to raise_error(ArgumentError)
      end
    end
  end
end
