# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  describe 'update a group member count' do
    context 'when the given group exist' do
      context 'and all correct params are given' do
        it 'returns the updated group' do
          params = { member_count: 330 }

          put api_group_path('telegram'), params: params

          expect(response.parsed_body).to include(
            'name' => 'telegram',
            'member_count' => 330
          )
        end

        it 'returns a success' do
          params = { member_count: 330 }

          put api_group_path('telegram'), params: params

          expect(response).to have_http_status(:ok)
        end
      end

      context 'and the member count is not informed' do
        it 'returns the error description' do
          params = { member_count: nil }

          put api_group_path('telegram'), params: params

          expect(response.parsed_body).to match(
            {
              'errors' => [{
                'detail' => 'não foi informado(a)',
                'field' => 'member_count'
              }]
            }
          )
        end

        it 'returns an unprocessable entity error' do
          params = { member_count: nil }

          put api_group_path('telegram'), params: params

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when the given group does not exist' do
      it 'returns a not found error' do
        params = { member_count: 330 }

        put api_group_path('inexistent_group'), params: params

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
