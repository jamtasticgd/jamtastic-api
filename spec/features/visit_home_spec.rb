# frozen_string_literal: true

require 'rails_helper'

describe 'Visit the home page', type: :feature do
  it 'renders the community name' do
    visit root_path

    expect(page).to have_content('Jamtastic')
  end

  it 'renders the community description' do
    visit root_path

    expect(page).to have_content('Uma comunidade de desenvolvimento de jogos brasileira.')
  end
end
