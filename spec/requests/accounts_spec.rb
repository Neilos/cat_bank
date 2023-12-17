# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accounts' do
  describe 'GET /account' do
    let(:user) { create(:user) }
    let(:account) { create(:account, user:) }

    before do
      user
      account
    end

    context 'when the user is logged in' do
      it 'returns http success' do
        sign_in user

        get '/account'

        expect(response).to have_http_status(:success)
      end
    end

    context 'when the user is not logged in' do
      it 'redirects to the login page' do
        get '/account'

        expect(response).to redirect_to(
          controller: 'devise/sessions',
          action: 'new'
        )
      end
    end
  end
end
