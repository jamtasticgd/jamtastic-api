# frozen_string_literal: true

require 'rails_helper'

feature 'Sign up an user' do
  it 'renders the sign up page' do
    visit new_user_registration_path

    expect(page).to have_content('Sign up')
  end
end
