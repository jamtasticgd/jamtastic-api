# frozen_string_literal: true

require 'rails_helper'

feature 'Sign in an user' do
  it 'renders the sign in page' do
    visit new_user_session_path

    expect(page).to have_content('Log in')
  end
end
