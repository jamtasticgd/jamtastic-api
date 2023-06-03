require 'rails_helper'

RSpec.describe RemoveEnrollment do
  describe '#call' do
    context 'when the team exists' do
      context 'and the enrollment exists' do
        context 'and is not an admin enrollment' do
          context 'when the user to be removed is the same user removing it' do
            it 'removes the enrollment' do
              user = create(:user)
              team = create(:team, :with_admin)
              user_enrollment = create(:team_member, team: team, user: user)

              expect {
                described_class.new(user: user, team_id: team.id, team_member_id: user_enrollment.id).call
              }.to change(TeamMember, :count).by(-1)
            end
          end

          context 'when the user to be removed is not the same user removing it' do
            context 'and the user is the team admin' do
              it 'removes the enrollment' do
                user = create(:user)
                team = create(:team)
                create(:team_member, :admin, team: team, user: user)
                other_user_enrollment = create(:team_member, team: team)

                expect {
                  described_class.new(user: user, team_id: team.id, team_member_id: other_user_enrollment.id).call
                }.to change(TeamMember, :count).by(-1)
              end
            end

            context 'but the user is not the team admin' do
              it 'raises a can not remove others error' do
                user = create(:user)
                team = create(:team, :with_admin)
                create(:team_member, team: team, user: user)
                other_user_enrollment = create(:team_member, team: team)

                expect {
                  described_class.new(user: user, team_id: team.id, team_member_id: other_user_enrollment.id).call
                }.to raise_error(RemoveEnrollment::CantRemoveOthersError)
              end
            end
          end
        end

        context 'and is an admin enrollment' do
          it 'raises a can not remove admin error' do
            team = create(:team, :with_admin)
            admin_team_member = team.team_members.first
            user = admin_team_member.user

            expect {
              described_class.new(user: user, team_id: team.id, team_member_id: admin_team_member.id).call
            }.to raise_error(RemoveEnrollment::CantRemoveAdminError)
          end
        end
      end

      context 'and the enrollment does not exists' do
        it 'raises a record not found error' do
          team = create(:team, :with_admin)
          user = team.owner

          expect {
            described_class.new(user: user, team_id: team.id, team_member_id: 'unknown_team_member_id').call
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when the team does not exist' do
      it 'raises a record not found error' do
        user = create(:user)

        expect {
          described_class.new(user: user, team_id: 'unknown_team_id', team_member_id: 1).call
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
