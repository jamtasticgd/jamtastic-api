# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Skills', type: :request do
  context 'when some skills exist' do
    it 'returns an ok status' do
      get skills_path

      expect(response).to have_http_status(:ok)
    end

    it 'returns the skills' do
      get skills_path

      expect(response.parsed_body).to match(
        [
          { 'code' => 'art' },
          { 'code' => 'audio' },
          { 'code' => 'code' },
          { 'code' => 'game_design' },
          { 'code' => 'writing' }
        ]
      )
    end
  end

  context 'when no skills exist' do
    before do
      Skill.delete_all
    end

    it 'returns an ok status' do
      get skills_path

      expect(response).to have_http_status(:ok)
    end

    it 'retuns an empty json' do
      get skills_path

      expect(response.parsed_body).to match([])
    end
  end
end
