# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'viewing account' do
  let(:user1) { create(:user, email: 'user1@example.com') }
  let(:user2) { create(:user, email: 'user2@example.com') }

  let(:account1) { create(:account, user: user1) }
  let(:account2) { create(:account, user: user2) }

  before do
    account1
    account2
  end

  context 'when user is not signed in' do
    it 'redirects them to sign in' do
      visit 'account'

      expect(page).to have_current_path(new_user_session_path)

      expect(page).to have_text(
        'You need to sign in or sign up before continuing.'
      )
    end
  end

  context 'when user is signed in' do
    before do
      sign_in user2
    end

    context 'without any transactions' do
      let(:expected_account2_balance) { 0.to_money(:seu).format }

      it 'shows relevant zero account balance' do
        visit 'account'

        expect(page).to have_current_path(user_account_root_path)

        expect(page).to have_content('Account Reference')
        expect(page).to have_content(account2.reference)
        expect(page).to have_content('Account Balance')
        expect(page).to have_content(expected_account2_balance)
      end
    end

    context 'with transactions' do
      let(:money_transaction1) do
        create(:money_transaction, created_at: 2.days.ago)
      end
      let(:money_transaction2) do
        create(:money_transaction, created_at: 1.day.ago)
      end

      let(:money_transaction1_account1_item1) do
        create(
          :money_transaction_item,
          account: account1,
          money_transaction: money_transaction1,
          amount: -16.to_money(:seu),
          account_balance: -16.to_money(:seu)
        )
      end
      let(:money_transaction1_account2_item1) do
        create(
          :money_transaction_item,
          money_transaction: money_transaction1,
          account: account2,
          amount: 10.to_money(:seu),
          account_balance: 10.to_money(:seu)
        )
      end
      let(:money_transaction1_account2_item2) do
        create(
          :money_transaction_item,
          account: account2,
          money_transaction: money_transaction1,
          amount: 6.to_money(:seu),
          account_balance: money_transaction1_account2_item1.account_balance +
                           6.to_money(:seu)
        )
      end

      let(:money_transaction2_account1_item1) do
        create(
          :money_transaction_item,
          account: account1,
          money_transaction: money_transaction2,
          amount: 2.to_money(:seu),
          account_balance: -14.to_money(:seu)
        )
      end
      let(:money_transaction2_account2_item1) do
        create(
          :money_transaction_item,
          money_transaction: money_transaction2,
          account: account2,
          amount: -2.to_money(:seu),
          account_balance: 14.to_money(:seu)
        )
      end

      let(:expected_account2_balance) do
        money_transaction1_account2_item1.account_balance.format
      end

      before do
        money_transaction1
        money_transaction1_account1_item1
        money_transaction1_account2_item1
        money_transaction1_account2_item2

        money_transaction2
        money_transaction2_account1_item1
        money_transaction2_account2_item1
      end

      it 'shows relevant account balance' do
        visit 'account'

        expect(page).to have_current_path(user_account_root_path)

        expect(page).to have_content('Account Reference')
        expect(page).to have_content(account2.reference)
        expect(page).to have_content('Account Balance')
        expect(page).to have_content(expected_account2_balance)
      end

      it 'lists the transactions with most recent first' do
        visit 'account'

        expect(page).to have_current_path(user_account_root_path)

        expect(page).to have_table(
          'Transactions',
          with_rows: [
            {
              'Time' => '1 day ago',
              'Ref' => money_transaction2.reference,
              'Description' => money_transaction2.description,
              'Amount' => money_transaction2_account2_item1.amount,
              'Balance' => money_transaction2_account2_item1.account_balance
            },
            {
              'Time' => '2 days ago',
              'Ref' => money_transaction1.reference,
              'Description' => money_transaction1.description,
              'Amount' => money_transaction1_account2_item2.amount,
              'Balance' => money_transaction1_account2_item2.account_balance
            },
            {
              'Time' => '2 days ago',
              'Ref' => money_transaction1.reference,
              'Description' => money_transaction1.description,
              'Amount' => money_transaction1_account2_item1.amount,
              'Balance' => money_transaction1_account2_item1.account_balance
            }
          ]
        )
      end
    end
  end
end
