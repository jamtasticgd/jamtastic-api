require 'rails_helper'

RSpec.describe 'Welcome API' do
  describe 'GET /' do
    it 'returns success status' do
      get '/'
      expect(response).to have_http_status(:success)
    end

    it 'returns JSON content type' do
      get '/'
      expect(response.content_type).to include('application/json')
    end

    it 'returns health check data structure' do
      get '/'
      json_response = response.parsed_body
      expect(json_response).to include('status', 'timestamp', 'environment', 'version')
    end

    it 'returns healthy status' do
      get '/'
      json_response = response.parsed_body
      expect(json_response['status']).to eq('healthy')
    end
  end
end
