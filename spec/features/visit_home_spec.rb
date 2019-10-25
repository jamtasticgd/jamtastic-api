# frozen_string_literal: true

require 'rails_helper'

feature 'Visit the home page' do
  it 'renders the home' do
    visit root_path

    expect(page).to have_content('Jamtastic')
    expect(page).to have_content('Uma comunidade de desenvolvimento de jogos brasileira.')
  end
end
