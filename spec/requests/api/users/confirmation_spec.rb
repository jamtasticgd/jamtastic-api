# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Confirm the user', type: :request do
  context 'when the informed token exists' do
    context 'and the user is not confirmed' do
      it 'returns an ok status' do
        travel_to 1.year.from_now

        user = users(:unconfirmed_user)
        params = { confirmation_token: user.confirmation_token }

        get user_confirmation_path(params)

        expect(response).to have_http_status(:ok)
      end

      it 'returns a confirmation message' do
        user = users(:unconfirmed_user)
        params = { confirmation_token: user.confirmation_token }

        get user_confirmation_path(params)

        expect(response.parsed_body).to match({
          'success' => true,
          'message' => 'Conta confirmada.'
        })
      end
    end

    context 'and the user is confirmed' do
      it 'returns an ok status' do
        user = users(:confirmed_user)
        params = { confirmation_token: user.confirmation_token }

        get user_confirmation_path(params)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'when the user does not exists' do
    it 'returns a not found error' do
      params = { confirmation_token: 'unknown_confirmation_token' }

      get user_confirmation_path(params)

      expect(response).to have_http_status(:not_found)
    end
  end
end
