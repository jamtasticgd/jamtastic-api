# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users::ItchioOauth', type: :request do
  let(:user) { create(:user) }
  let(:itchio_client_id) { 'test_client_id' }

  before do
    Rails.application.config.itchio_oauth.client_id = itchio_client_id
  end



  describe 'GET /users/itchio_oauth/authorize' do
    context 'when itch.io OAuth is configured' do
      it 'redirects to itch.io authorization URL' do
        get '/users/itchio_oauth/authorize'

        expect(response).to have_http_status(:redirect)
        expect(response.location).to include('https://itch.io/user/oauth')
        expect(response.location).to include("client_id=#{itchio_client_id}")
        expect(response.location).to include('scope=profile%3Ame')
      end

      it 'stores state in session' do
        get '/users/itchio_oauth/authorize'

        expect(session[:itchio_oauth_state]).to be_present
      end
    end

    context 'when itch.io OAuth is not configured' do
      before do
        Rails.application.config.itchio_oauth.client_id = nil
      end

      it 'returns service unavailable error' do
        get '/users/itchio_oauth/authorize'

        expect(response).to have_http_status(:service_unavailable)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'itch.io OAuth is not configured' })
      end
    end
  end

  describe 'GET /users/itchio_oauth/callback' do
    let(:access_token) { 'test_access_token' }
    let(:state) { 'test_state' }
    let(:itchio_data) do
      {
        itchio_id: '12345',
        itchio_username: 'testuser',
        itchio_access_token: access_token
      }
    end

    before do
      session[:itchio_oauth_state] = state
      allow(ItchioOauthService).to receive(:exchange_code_for_token).with(access_token).and_return(itchio_data)
    end

    context 'with valid parameters' do
      it 'authenticates user with itch.io data' do
        get '/users/itchio_oauth/callback', params: { access_token: access_token, state: state }

        expect(response).to have_http_status(:ok)
        response_data = JSON.parse(response.body)
        expect(response_data['data']['user']['itchio_username']).to eq('testuser')
        expect(response_data['data']['tokens']).to be_present
      end

      it 'clears state from session' do
        get '/users/itchio_oauth/callback', params: { access_token: access_token, state: state }

        expect(session[:itchio_oauth_state]).to be_nil
      end
    end

    context 'with invalid state' do
      it 'returns bad request error' do
        get '/users/itchio_oauth/callback', params: { access_token: access_token, state: 'invalid_state' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid state parameter' })
      end
    end

    context 'with missing access token' do
      it 'returns bad request error' do
        get '/users/itchio_oauth/callback', params: { state: state }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Access token not provided' })
      end
    end

    context 'when itch.io data fetch fails' do
      before do
        allow(ItchioOauthService).to receive(:exchange_code_for_token).with(access_token).and_return(nil)
      end

      it 'returns unprocessable entity error' do
        get '/users/itchio_oauth/callback', params: { access_token: access_token, state: state }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Failed to fetch itch.io user data' })
      end
    end
  end

  describe 'POST /users/itchio_oauth/link_account' do
    let(:access_token) { 'test_access_token' }
    let(:itchio_data) do
      {
        itchio_id: '12345',
        itchio_username: 'testuser',
        itchio_access_token: access_token
      }
    end

    before do
      sign_in user
      allow(ItchioOauthService).to receive(:validate_access_token).with(access_token).and_return(true)
      allow(ItchioOauthService).to receive(:exchange_code_for_token).with(access_token).and_return(itchio_data)
    end

    context 'with valid access token' do
      it 'links itch.io account to current user' do
        post '/users/itchio_oauth/link_account', params: { access_token: access_token }

        expect(response).to have_http_status(:ok)
        response_data = JSON.parse(response.body)
        expect(response_data['message']).to eq('itch.io account linked successfully')
        expect(response_data['user']['itchio_username']).to eq('testuser')

        user.reload
        expect(user.itchio_id).to eq('12345')
        expect(user.itchio_username).to eq('testuser')
        expect(user.itchio_access_token).to eq(access_token)
      end
    end

    context 'with invalid access token' do
      before do
        allow(ItchioOauthService).to receive(:validate_access_token).with(access_token).and_return(false)
      end

      it 'returns unauthorized error' do
        post '/users/itchio_oauth/link_account', params: { access_token: access_token }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid access token' })
      end
    end

    context 'when itch.io account is already linked to another user' do
      let(:other_user) { create(:user, itchio_id: '12345') }

      it 'returns conflict error' do
        post '/users/itchio_oauth/link_account', params: { access_token: access_token }

        expect(response).to have_http_status(:conflict)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'This itch.io account is already linked to another user' })
      end
    end

    context 'without authentication' do
      before do
        sign_out user
      end

      it 'returns unauthorized error' do
        post '/users/itchio_oauth/link_account', params: { access_token: access_token }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /users/itchio_oauth/unlink_account' do
    before do
      sign_in user
      user.update!(itchio_id: '12345', itchio_username: 'testuser', itchio_access_token: 'token')
    end

    it 'unlinks itch.io account from current user' do
      delete '/users/itchio_oauth/unlink_account'

      expect(response).to have_http_status(:ok)
      response_data = JSON.parse(response.body)
      expect(response_data['message']).to eq('itch.io account unlinked successfully')

      user.reload
      expect(user.itchio_id).to be_nil
      expect(user.itchio_username).to be_nil
      expect(user.itchio_access_token).to be_nil
    end

    context 'without authentication' do
      before do
        sign_out user
      end

      it 'returns unauthorized error' do
        delete '/users/itchio_oauth/unlink_account'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
