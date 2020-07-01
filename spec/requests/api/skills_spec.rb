# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Skills', type: :request do
  context 'when some skills exist' do
    it 'returns the skills' do
      get api_skills_path

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.size).to eq(5)
    end

    it 'return the skill code' do
      get api_skills_path

      art_skill = response.parsed_body.first

      expect(art_skill).to match(
        a_hash_including(
          'code' => 'art'
        )
      )
    end
  end

  context 'when no skills exist' do
    it 'retuns an empty json' do
      Skill.delete_all

      get api_skills_path

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to be_empty
    end
  end
end
