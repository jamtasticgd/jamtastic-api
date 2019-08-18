# frozen_string_literal: true

require 'rails_helper'
require 'faker'

feature 'Sign up an user' do
  it 'renders the sign up page' do
    visit new_user_registration_path

    expect(page).to have_content('Sign up')
  end

  context 'when all valid data is informed' do
    it 'creates a new user account' do
      visit new_user_registration_path

      email = Faker::Internet.email
      password = Faker::Internet.password

      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password

      click_on 'Sign up'
    end
  end

  context 'when an invalid data is informed' do
    it 'shows an invalid data message' do
      visit new_user_registration_path

      email = Faker::Internet.email
      password = Faker::Internet.password

      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password

      click_on 'Sign up'

      expect(page).to have_content('Confirme sua senha não é igual a Senha')
    end
  end
end
