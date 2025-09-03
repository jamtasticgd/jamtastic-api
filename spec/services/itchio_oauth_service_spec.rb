# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItchioOauthService, type: :service do
  describe '.authorization_url' do
    it 'generates correct authorization URL' do
      client_id = 'test_client_id'
      redirect_uri = 'https://example.com/callback'
      state = 'test_state'

      url = described_class.authorization_url(
        client_id: client_id,
        redirect_uri: redirect_uri,
        state: state
      )

      expect(url).to include('https://itch.io/user/oauth')
      expect(url).to include("client_id=#{client_id}")
      expect(url).to include('scope=profile%3Ame')
      expect(url).to include("redirect_uri=#{CGI.escape(redirect_uri)}")
      expect(url).to include("state=#{state}")
    end

    it 'generates URL without state when not provided' do
      client_id = 'test_client_id'
      redirect_uri = 'https://example.com/callback'

      url = described_class.authorization_url(
        client_id: client_id,
        redirect_uri: redirect_uri
      )

      expect(url).not_to include('state=')
    end
  end

  describe '.exchange_code_for_token' do
    let(:access_token) { 'test_access_token' }
    let(:user_info_response) do
      {
        'id' => 12345,
        'username' => 'testuser',
        'email' => 'test@example.com'
      }
    end

    before do
      allow(described_class).to receive(:fetch_user_info).with(access_token).and_return(user_info_response)
    end

    it 'returns itch.io data when user info is fetched successfully' do
      result = described_class.exchange_code_for_token(access_token)

      expect(result).to eq({
        itchio_id: '12345',
        itchio_username: 'testuser',
        itchio_access_token: access_token
      })
    end

    it 'returns nil when user info fetch fails' do
      allow(described_class).to receive(:fetch_user_info).with(access_token).and_return(nil)

      result = described_class.exchange_code_for_token(access_token)

      expect(result).to be_nil
    end
  end

  describe '.fetch_user_info' do
    let(:access_token) { 'test_access_token' }
    let(:successful_response) { double('response', success?: true, body: '{"id": 12345, "username": "testuser"}') }

    before do
      allow(Net::HTTP).to receive(:new).and_return(double('http', use_ssl: true))
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(successful_response)
    end

    it 'returns parsed user info on successful request' do
      result = described_class.fetch_user_info(access_token)

      expect(result).to eq({ 'id' => 12345, 'username' => 'testuser' })
    end

    it 'returns nil on failed request' do
      failed_response = double('response', success?: false)
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(failed_response)

      result = described_class.fetch_user_info(access_token)

      expect(result).to be_nil
    end

    it 'handles JSON parsing errors gracefully' do
      invalid_json_response = double('response', success?: true, body: 'invalid json')
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(invalid_json_response)

      expect(Rails.logger).to receive(:error).with(/Failed to fetch itch.io user info/)

      result = described_class.fetch_user_info(access_token)

      expect(result).to be_nil
    end
  end

  describe '.validate_access_token' do
    let(:access_token) { 'test_access_token' }

    it 'returns true for valid access token' do
      successful_response = double('response', success?: true)
      allow(described_class).to receive(:make_api_request).with('/credentials/info', access_token).and_return(successful_response)

      result = described_class.validate_access_token(access_token)

      expect(result).to be true
    end

    it 'returns false for invalid access token' do
      failed_response = double('response', success?: false)
      allow(described_class).to receive(:make_api_request).with('/credentials/info', access_token).and_return(failed_response)

      result = described_class.validate_access_token(access_token)

      expect(result).to be false
    end

    it 'returns false for blank access token' do
      result = described_class.validate_access_token('')

      expect(result).to be false
    end
  end
end
