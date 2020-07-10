# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Send email confirmation message', type: :request do
  context 'when the user exists' do
    context 'and the user is confirmed' do
      it 'send an message to confirm' do
        params = { email: 'confirmed@jamtastic.org' }

        expect do
          post(api_user_confirmation_path, params: params)
        end.to change(ActionMailer::Base.deliveries, :count).by(1)

        message = ActionMailer::Base.deliveries.last

        expect(message.to.join).to eq('confirmed@jamtastic.org')
        expect(message.subject).to eq('Instruções de confirmação')
      end

      it 'returns a sucess' do
        params = { email: 'confirmed@jamtastic.org' }
        post(api_user_confirmation_path, params: params)

        response_body = response.parsed_body

        expect(response_body['success']).to eq(true)
        expect(response_body['message']).to eq(
          'Se o seu email existir em nosso banco de dados, '\
          'você receberá um email com instruções sobre como confirmar sua conta em alguns minutos.'
        )
      end
    end

    context 'and the user is unconfirmed' do
      it 'sends an message to confirm the user e-mail' do
        params = { email: 'unconfirmed@jamtastic.org' }

        expect do
          post(api_user_confirmation_path, params: params)
        end.to change(ActionMailer::Base.deliveries, :count).by(1)

        message = ActionMailer::Base.deliveries.last

        expect(message.to.join).to eq('unconfirmed@jamtastic.org')
        expect(message.subject).to eq('Instruções de confirmação')
      end

      it 'returns a sucess' do
        params = { email: 'confirmed@jamtastic.org' }
        post(api_user_confirmation_path, params: params)

        response_body = response.parsed_body

        expect(response_body['success']).to eq(true)
        expect(response_body['message']).to eq(
          'Se o seu email existir em nosso banco de dados, '\
          'você receberá um email com instruções sobre como confirmar sua conta em alguns minutos.'
        )
      end
    end
  end

  context 'when the user does not exist' do
    it 'does not send an message' do
      params = { email: 'unknown@jamtastic.org' }

      expect do
        post(api_user_confirmation_path, params: params)
      end.to change(ActionMailer::Base.deliveries, :count).by(0)
    end

    it 'returns an error' do
      params = { email: 'unknown@jamtastic.org' }
      post(api_user_confirmation_path, params: params)

      response_body = response.parsed_body

      expect(response_body['success']).to eq(false)
      expect(response_body['errors'].join).to eq(
        'Se o seu email existir em nosso banco de dados, '\
        'você receberá um email com instruções sobre como confirmar sua conta em alguns minutos.'
      )
    end
  end
end
