# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign out a user', type: :request do
  context 'when the user is logged in' do
    it 'returns an ok status' do
      params = {
        email: 'confirmed@jamtastic.org',
        password: '123456'
      }
      post(api_user_session_path, params: params)

      headers = {
        uid: response.headers['uid'],
        client: response.headers['client'],
        'access-token': response.headers['access-token']
      }

      delete(destroy_api_user_session_path, headers: headers)

      expect(response).to have_http_status(:ok)
    end

    it 'returns a success' do
      params = {
        email: 'confirmed@jamtastic.org',
        password: '123456'
      }
      post(api_user_session_path, params: params)

      headers = {
        uid: response.headers['uid'],
        client: response.headers['client'],
        'access-token': response.headers['access-token']
      }

      delete(destroy_api_user_session_path, headers: headers)

      expect(response.parsed_body['success']).to eq(true)
    end
  end

  context 'when the user is logged out' do
    it 'returns a not found error' do
      headers = {
        uid: 'confirmed@jamtastic.org',
        client: 'q5m14mEsAQmd_8umNk5rqg',
        'access-token': '5x2J83hTFK8zK_yri-sXiA'
      }

      delete(destroy_api_user_session_path, headers: headers)

      expect(response).to have_http_status(:not_found)
    end

    it 'returns a failure' do
      headers = {
        uid: 'confirmed@jamtastic.org',
        client: 'q5m14mEsAQmd_8umNk5rqg',
        'access-token': '5x2J83hTFK8zK_yri-sXiA'
      }

      delete(destroy_api_user_session_path, headers: headers)

      expect(response.parsed_body['success']).to eq(false)
    end
  end
end
