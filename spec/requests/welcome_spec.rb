require 'rails_helper'

RSpec.describe 'Welcome API' do
  describe 'GET /' do
    it 'returns health check JSON' do
      get '/'
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response).to include('status', 'timestamp', 'environment', 'version')
      expect(json_response['status']).to eq('healthy')
    end
  end
end
