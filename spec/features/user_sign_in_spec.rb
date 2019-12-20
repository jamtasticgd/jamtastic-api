# frozen_string_literal: true

require 'rails_helper'

feature 'Sign in an user' do
  context 'when user data is informed correctly' do
    context 'and it is an unconfirmed user' do
      context 'and it is past the uncofirmed access period' do
        it 'does not log in' do
          user = users(:unconfirmed_user)
          password = '123456'

          visit root_path

          click_on 'Login'

          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: password

          click_on 'Log in'

          expect(page).to have_content('Antes de continuar, confirme a sua conta.')
        end
      end

      context 'and it is within the unconfirmed access period' do
        before { travel_to Time.zone.local(2019, 1, 1) }
        after { travel_back }

        it 'logins sucessfully' do
          user = users(:unconfirmed_user)
          password = '123456'

          visit root_path

          click_on 'Login'

          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: password

          click_on 'Log in'

          expect(page).to have_content('Login efetuado com sucesso.')
        end
      end
    end

    context 'and it is an confirmed user' do
      it 'logins sucessfully' do
        user = users(:confirmed_user)
        password = '123456'

        visit root_path

        click_on 'Login'

        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: password

        click_on 'Log in'

        expect(page).to have_content('Login efetuado com sucesso.')
      end
    end
  end

  context 'when user data is informed incorrectly' do
    it 'does not log in' do
      user = users(:confirmed_user)
      password = '124356'

      visit root_path

      click_on 'Login'

      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: password

      click_on 'Log in'

      expect(page).to have_content('Email ou senha inválidos.')
    end
  end
end
