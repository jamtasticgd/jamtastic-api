require 'rails_helper'

RSpec.describe ApproveEnrollment, type: :service do
  describe '#call' do
    context 'when a valid enrollment is informed' do
      context 'and the member is not approved' do
        it 'approves the member' do
          team_member = team_members(:pending_member)

          described_class.new(team_member).call
          team_member.reload

          expect(team_member).to be_approved
        end
      end

      context 'but the member is already approved' do
        it 'raises an already approved error' do
          team_member = team_members(:approved_member)

          expect {
            described_class.new(team_member).call
          }.to raise_error(ApproveEnrollment::AlreadyApprovedError)
        end
      end
    end

    context 'when an invalid enrollment is informed' do
      it 'raises an argument error' do
        expect {
          described_class.new(nil).call
        }.to raise_error(ArgumentError)
      end
    end
  end
end
