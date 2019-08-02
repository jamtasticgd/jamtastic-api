# frozen_string_literal: true

require 'rails_helper'

feature 'Visit the home page' do
  it 'renders the home' do
    visit root_path

    expect(page).to have_content('Jamtastic')
  end
end
