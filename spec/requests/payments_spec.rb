# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Payments' do
  describe 'GET accounts/:account_id/payments/new' do
    let(:user) { create(:user) }
    let(:account) { create(:account, user: user) }
    let(:path) { new_account_payments_path(account) }

    before do
      user
      account
    end

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      context 'when the account belongs to the user' do
        it 'returns http success' do
          get path

          expect(response).to have_http_status(:success)
        end
      end

      context 'when the account does *not* belong to the user' do
        let(:account) { create(:account) }

        it 'returns http forbidden' do
          get path

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'when the user is not logged in' do
      it 'redirects to the login page' do
        get path

        expect(response).to redirect_to(
          controller: 'devise/sessions',
          action: 'new'
        )
      end
    end
  end

  describe 'POST accounts/:account_id/payments/create' do
    let(:user) { create(:user) }
    let(:account) { create(:account, user: user) }
    let(:another_account) { create(:account) }
    let(:path) { account_payments_path(account) }
    let(:valid_params) do
      {
        payment: {
          description: 'bank transfer',
          to_account_reference: another_account.reference,
          amount: 2
        }
      }
    end

    before do
      user
      account
      another_account
    end

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      context 'when the account belongs to the user' do
        context 'with valid parameters' do
          it 'redirects to the account show page' do
            post path, params: valid_params

            expect(response).to redirect_to(user_account_root_path)
          end
        end

        context 'with invalid parameters' do
          it 'returns http success but renders the new page again' do
            post path, params: {
              payment: {
                description: 'bank transfer',
                to_account_reference: nil, # invalid
                amount: 'hello' # invalid
              }
            }

            expect(response).to have_http_status(:success)
          end
        end
      end

      context 'when the account does *not* belong to the user' do
        let(:account) { another_account }

        it 'returns http forbidden' do
          post path, params: valid_params

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'when the user is not logged in' do
      it 'redirects to the login page' do
        post path, params: valid_params

        expect(response).to redirect_to(
          controller: 'devise/sessions',
          action: 'new'
        )
      end
    end
  end
end
