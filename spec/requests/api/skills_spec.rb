# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Skills API', type: :request do
  path '/skills' do
    get 'List all skills' do
      tags 'Skills'
      description 'Retrieve a list of all available skills'
      produces 'application/json'

      response '200', 'Skills retrieved successfully' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   code: { type: :string, description: 'Skill code identifier' }
                 }
               }

        let!(:skill1) { create(:skill, code: 'ruby') }
        let!(:skill2) { create(:skill, code: 'javascript') }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
          expect(data.length).to eq(2)
          expect(data.map { |s| s['code'] }).to contain_exactly('ruby', 'javascript')
        end
      end
    end
  end
end