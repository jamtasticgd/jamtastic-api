# frozen_string_literal: true

require 'rails_helper'
require 'faker'

feature 'Sign up an user' do
  context 'when all valid data is informed' do
    it 'creates a new user account' do
      visit root_path

      click_on 'Login'
      click_on 'Inscrever-se'

      email = Faker::Internet.email
      password = Faker::Internet.password

      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password

      click_on 'Inscrever-se'
    end
  end

  context 'when an invalid data is informed' do
    it 'shows an invalid data message' do
      visit root_path

      click_on 'Login'
      click_on 'Inscrever-se'

      email = Faker::Internet.email
      password = Faker::Internet.password

      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password

      click_on 'Inscrever-se'

      expect(page).to have_content('Confirme sua senha não é igual a Senha')
    end
  end
end
