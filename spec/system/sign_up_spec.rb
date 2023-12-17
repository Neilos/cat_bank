# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signing up' do
  let(:user_email) { 'test@example.com' }
  let(:user_password) { 'password123!!' }
  let(:sign_up_actions) do
    proc do
      visit '/'

      click_link 'Sign up'

      fill_in 'Email', with: user_email
      fill_in 'Password', with: user_password
      fill_in 'Password confirmation', with: user_password

      click_button 'Sign up'
    end
  end

  it 'signs the user up, logs them in and redirects to the accounts show page' do
    sign_up_actions.call

    expect(page).to have_text('Welcome! You have signed up successfully')
    expect(page).to have_current_path(user_account_root_path)
  end

  it 'creates the user and an account' do
    expect do
      sign_up_actions.call
      expect(page).to have_text('Welcome!')
    end.to(
      change(User, :count).by(1).and(
        change(Account, :count).by(1)
      )
    )
  end
end
