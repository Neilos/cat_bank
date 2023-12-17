# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signing in' do
  let(:user_email) { 'test@example.com' }
  let(:user_password) { 'password123!!' }
  let(:user) do
    create(
      :user,
      email: user_email,
      password: user_password,
      password_confirmation: user_password
    )
  end
  let(:account) { create(:account, user:) }

  before do
    user
    account
  end

  it 'signs the user in and redirects to the accounts show page' do
    visit '/'

    fill_in 'Email', with: user_email
    fill_in 'Password', with: user_password

    click_button 'Log in'

    expect(page).to have_text('Signed in successfully')
    expect(page).to have_current_path(user_account_root_path)
  end
end
