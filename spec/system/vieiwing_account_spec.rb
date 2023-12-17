# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'viewing account' do
  let(:account1) { create(:account) }
  let(:account2) { create(:account) }

  before do
    account1
    account2
  end

  context 'without any transactions' do
    let(:expected_account2_balance) { 0.to_money(:seu).format }

    it 'shows relevant zero account balance' do
      visit "accounts/#{account2.id}"

      expect(page).to have_content('Account Reference')
      expect(page).to have_content(account2.reference)
      expect(page).to have_content('Account Balance')
      expect(page).to have_content(expected_account2_balance)
    end
  end

  context 'with transactions' do
    let(:money_transaction1) { create(:money_transaction) }

    let(:account1_money_transacction_item1) do
      create(
        :money_transaction_item,
        account: account1,
        money_transaction: money_transaction1,
        amount: -16.to_money(:seu),
        account_balance: -16.to_money(:seu)
      )
    end

    let(:account2_money_transacction_item1) do
      create(
        :money_transaction_item,
        money_transaction: money_transaction1,
        account: account2,
        amount: 10.to_money(:seu),
        account_balance: 10.to_money(:seu)
      )
    end
    let(:account2_money_transacction_item2) do
      create(
        :money_transaction_item,
        account: account2,
        money_transaction: money_transaction1,
        amount: 6.to_money(:seu),
        account_balance: account2_money_transacction_item1.account_balance +
                         6.to_money(:seu)
      )
    end

    let(:expected_account2_balance) do
      account2_money_transacction_item2.account_balance.format
    end

    before do
      account1_money_transacction_item1
      account2_money_transacction_item1
      account2_money_transacction_item2
    end

    it 'shows relevant account balance' do
      visit "accounts/#{account2.id}"

      expect(page).to have_content('Account Reference')
      expect(page).to have_content(account2.reference)
      expect(page).to have_content('Account Balance')
      expect(page).to have_content(expected_account2_balance)
    end
  end
end
