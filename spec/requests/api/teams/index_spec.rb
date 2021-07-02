# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List teams', type: :request do
  context 'when there are teams registered' do
    before do
      create(
        :team,
        name: 'Happy Madison Productions',
        description: 'We are a team making great games and movies.'
      )
    end

    it 'returns an array containing the teams' do
      get(api_teams_path)

      expect(response.parsed_body).to match(
        [
          a_hash_including(
            'name' => 'Happy Madison Productions',
            'description' => 'We are a team making great games and movies.',
            'needed_skills' => []
          )
        ]
      )
    end

    it 'returns an ok status' do
      get(api_teams_path)

      expect(response).to have_http_status(:ok)
    end
  end

  context 'when there are no teams registered' do
    it 'returns an ok status' do
      get(api_teams_path)

      expect(response).to have_http_status(:ok)
    end

    it 'returns an empty array' do
      get(api_teams_path)

      expect(response.parsed_body).to match([])
    end
  end
end
