# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'viewing home page' do
  it 'renders the page' do
    visit '/'
    expect(page).to have_content 'HomePage#show'
  end
end
