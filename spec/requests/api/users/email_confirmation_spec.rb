# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Send email confirmation message' do
  before do
    create(:confirmed_user)
    create(:unconfirmed_user)
  end

  context 'when the user exists' do
    context 'and the user is confirmed' do
      it 'send a message to the user' do
        params = { email: 'confirmed-test@jamtastic.org' }

        post(user_confirmation_path, params:)

        message = ActionMailer::Base.deliveries.last

        expect(message.to.join).to eq('confirmed-test@jamtastic.org')
      end

      it 'sends the confirmation instructions to the user' do
        params = { email: 'confirmed-test@jamtastic.org' }

        post(user_confirmation_path, params:)

        message = ActionMailer::Base.deliveries.last

        expect(message.subject).to eq('Instruções de confirmação')
      end

      it 'returns a sucess' do
        params = { email: 'confirmed-test@jamtastic.org' }
        post(user_confirmation_path, params:)

        response_body = response.parsed_body

        expect(response_body['success']).to be(true)
      end

      it 'returns a confirmation message' do
        params = { email: 'confirmed-test@jamtastic.org' }
        post(user_confirmation_path, params:)

        response_body = response.parsed_body

        expect(response_body['message']).to eq(
          'Se o seu email existir em nosso banco de dados, ' \
          'você receberá um email com instruções sobre como confirmar sua conta em alguns minutos.'
        )
      end
    end

    context 'and the user is unconfirmed' do
      it 'sends an message to the user' do
        params = { email: 'unconfirmed-test@jamtastic.org' }

        post(user_confirmation_path, params:)

        message = ActionMailer::Base.deliveries.last

        expect(message.to.join).to eq('unconfirmed-test@jamtastic.org')
      end

      it 'sends the confirmation instructions to the user' do
        params = { email: 'unconfirmed-test@jamtastic.org' }

        post(user_confirmation_path, params:)

        message = ActionMailer::Base.deliveries.last

        expect(message.subject).to eq('Instruções de confirmação')
      end

      it 'returns a sucess' do
        params = { email: 'confirmed-test@jamtastic.org' }
        post(user_confirmation_path, params:)

        response_body = response.parsed_body

        expect(response_body['success']).to be(true)
      end

      it 'returns a confirmation message' do
        params = { email: 'confirmed-test@jamtastic.org' }
        post(user_confirmation_path, params:)

        response_body = response.parsed_body

        expect(response_body['message']).to eq(
          'Se o seu email existir em nosso banco de dados, ' \
          'você receberá um email com instruções sobre como confirmar sua conta em alguns minutos.'
        )
      end
    end
  end

  context 'when the user does not exist' do
    it 'does not send an message' do
      params = { email: 'unknown@jamtastic.org' }

      expect {
        post(user_confirmation_path, params:)
      }.not_to change(ActionMailer::Base.deliveries, :count)
    end

    it 'returns an error' do
      params = { email: 'unknown@jamtastic.org' }
      post(user_confirmation_path, params:)

      response_body = response.parsed_body

      expect(response_body['success']).to be(true)
    end

    it 'returns a confirmation message' do
      params = { email: 'unknown@jamtastic.org' }
      post(user_confirmation_path, params:)

      response_body = response.parsed_body

      expect(response_body['message']).to eq(
        'Se o seu email existir em nosso banco de dados, ' \
        'você receberá um email com instruções sobre como confirmar sua conta em alguns minutos.'
      )
    end
  end
end
