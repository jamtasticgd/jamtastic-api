# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign up a user', type: :request do
  let(:params) do
    {
      name: 'Adam Sandler',
      email: 'adam@sandler.com',
      password: '123456',
      password_confirmation: '123456',
      telegram: 'adam.sandler'
    }
  end

  context 'when the user does not exist' do
    it 'returns a success' do
      post(api_user_registration_path, params: params)

      expect(response).to have_http_status(:ok)
    end

    it 'creates a new user' do
      expect do
        post(api_user_registration_path, params: params)
      end.to change(User, :count).by(1)
    end

    it 'creates a new user with the given email' do
      post(api_user_registration_path, params: params)

      user = User.find_by(email: 'adam@sandler.com')

      expect(user).to be_present
    end

    it 'creates a new user with the given name' do
      post(api_user_registration_path, params: params)

      user = User.find_by(email: 'adam@sandler.com')

      expect(user.name).to eq('Adam Sandler')
    end

    it 'creates a new user with the given telegram user name' do
      post(api_user_registration_path, params: params)

      user = User.find_by(email: 'adam@sandler.com')

      expect(user.telegram).to eq('adam.sandler')
    end

    it 'sends an confirmation e-mail to the user' do
      expect do
        post(api_user_registration_path, params: params)
      end.to change(ActionMailer::Base.deliveries, :count).by(1)

      message = ActionMailer::Base.deliveries.last

      expect(message.to.join).to eq('adam@sandler.com')
      expect(message.subject).to eq('Instruções de confirmação')
    end
  end

  context 'when the user does not exist' do
    before do
      post(api_user_registration_path, params: params)
    end

    it 'returns an unprocessable entity error' do
      post(api_user_registration_path, params: params)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
