# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign up a user', type: :request do
  context 'when the user exists' do
    context 'and the password is correct' do
      context 'and it is an confirmed user' do
        it 'signs in the user' do
          params = {
            email: 'confirmed@jamtastic.org',
            password: '123456'
          }
          post(new_api_user_session_path, params: params)

          response_body = response.parsed_body

          expect(response_body.any?('errors')).to eq(false)
          expect(response_body.dig('data', 'email')).to eq('confirmed@jamtastic.org')
        end
      end

      context 'and it is an unconfirmed user' do
        context 'and it is past the uncofirmed access period' do
          it 'does not sign in the user' do
            params = {
              email: 'unconfirmed@jamtastic.org',
              password: '1234567890'
            }
            post(new_api_user_session_path, params: params)

            response_body = response.parsed_body

            expect(response_body['success']).to eq(false)
            expect(response_body['errors'].join).to eq(
              'Uma mensagem com um link de confirmação foi enviado para seu endereço de e-mail.'\
              ' Você precisa confirmar sua conta antes de continuar.'
            )
          end
        end

        context 'and it is within the unconfirmed access period' do
          before { travel_to Time.zone.local(2019, 1, 1) }
          after { travel_back }

          it 'signs in the user' do
            params = {
              email: 'unconfirmed@jamtastic.org',
              password: '123456'
            }
            post(new_api_user_session_path, params: params)

            response_body = response.parsed_body

            expect(response_body.any?('errors')).to eq(false)
            expect(response_body.dig('data', 'email')).to eq('unconfirmed@jamtastic.org')
          end
        end
      end
    end

    context 'and the password is incorrect' do
      it 'does not sign in the user' do
        params = {
          email: 'confirmed@jamtastic.org',
          password: '1234567890'
        }
        post(new_api_user_session_path, params: params)

        response_body = response.parsed_body

        expect(response_body['success']).to eq(false)
        expect(response_body['errors'].join).to eq('E-mail ou senha inválidos.')
      end
    end
  end

  context 'when the user does not exist' do
    it 'does not sign in the user' do
      params = {
        email: 'unknown@jamtastic.org',
        password: '123456'
      }
      post(new_api_user_session_path, params: params)

      response_body = response.parsed_body

      expect(response_body['success']).to eq(false)
      expect(response_body['errors'].join).to eq('E-mail ou senha inválidos.')
    end
  end

  context 'when the user signs in successfully' do
    before do
      params = {
        email: 'confirmed@jamtastic.org',
        password: '123456'
      }
      post(new_api_user_session_path, params: params)
    end

    it 'returns a bearer token type' do
      expect(response.headers['token-type']).to eq('Bearer')
    end

    it 'returns the user uid' do
      expect(response.headers['uid']).to eq('confirmed@jamtastic.org')
    end

    it 'returns an access token' do
      expect(response.headers['access-token']).to be_present
    end

    it 'returns the client token' do
      expect(response.headers['client']).to be_present
    end
  end
end
