# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/users' do
    post 'Register a new user' do
      tags 'Users'
      description 'Register a new user account'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email, description: 'User email address' },
          password: { type: :string, description: 'User password' },
          password_confirmation: { type: :string, description: 'Password confirmation' },
          name: { type: :string, description: 'User full name' },
          telegram: { type: :string, description: 'Telegram username' },
          known_skills: {
            type: :array,
            items: { type: :string },
            description: 'List of skill codes the user knows'
          }
        },
        required: ['email', 'password', 'password_confirmation']
      }

      response '200', 'User registered successfully' do
        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     name: { type: :string },
                     telegram: { type: :string },
                     created_at: { type: :string, format: :date_time },
                     updated_at: { type: :string, format: :date_time }
                   }
                 }
               }

        let(:user) do
          {
            email: 'test@example.com',
            password: 'password123',
            password_confirmation: 'password123',
            name: 'Test User',
            telegram: '@testuser',
            known_skills: ['ruby', 'javascript']
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data']['email']).to eq('test@example.com')
          expect(data['data']['name']).to eq('Test User')
        end
      end

      response '422', 'Validation error' do
        schema '$ref' => '#/components/schemas/error'

        let(:user) { { email: 'invalid-email', password: '123' } }

        run_test!
      end
    end
  end

  path '/users/sign_in' do
    post 'Sign in user' do
      tags 'Users'
      description 'Authenticate user and return access token'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email, description: 'User email address' },
          password: { type: :string, description: 'User password' }
        },
        required: ['email', 'password']
      }

      response '200', 'User signed in successfully' do
        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     name: { type: :string },
                     telegram: { type: :string }
                   }
                 },
                 access_token: { type: :string },
                 client: { type: :string },
                 uid: { type: :string }
               }

        let!(:existing_user) { create(:user, email: 'test@example.com', password: 'password123') }
        let(:credentials) do
          {
            email: 'test@example.com',
            password: 'password123'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data']['email']).to eq('test@example.com')
          expect(data['access_token']).to be_present
        end
      end

      response '401', 'Invalid credentials' do
        schema '$ref' => '#/components/schemas/error'

        let(:credentials) do
          {
            email: 'test@example.com',
            password: 'wrongpassword'
          }
        end

        run_test!
      end
    end
  end

  path '/users/sign_out' do
    delete 'Sign out user' do
      tags 'Users'
      description 'Sign out user and invalidate access token'
      security [bearer_auth: []]

      response '200', 'User signed out successfully' do
        let(:user) { create(:user) }
        let(:auth_headers) { user.create_new_auth_token }

        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/error'

        run_test!
      end
    end
  end
end
