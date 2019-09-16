# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  describe 'update a group member count' do
    context 'when the given group exist' do
      context 'and all correct params are given' do
        it 'updates a group' do
          group = groups(:telegram)
          params = { member_count: 330 }

          put api_group_path(group.name), params: params
          group.reload

          expect(group.member_count).to be(330)
        end
      end

      context 'and the member count is not informed' do
        it 'returns an unprocessable entity error' do
          group = groups(:telegram)
          params = { member_count: nil }

          put api_group_path(group.name), params: params

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when the given group does not exist' do
      it 'returns a not found error' do
        params = { member_count: 330 }
        put api_group_path('telegran'), params: params

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
