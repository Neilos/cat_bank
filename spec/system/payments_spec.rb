# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'payments' do
  let(:user1) { create(:user, email: 'user1@example.com') }
  let(:user2) { create(:user, email: 'user2@example.com') }

  let(:account1) { create(:account, user: user1) }
  let(:account2) { create(:account, user: user2) }

  let(:initial_money_transaction) do
    create(
      :money_transaction,
      description: 'initial transaction',
      created_at: 1.day.ago
    )
  end
  let(:initial_money_transaction_account1_item1) do
    create(
      :money_transaction_item,
      account: account1,
      money_transaction: initial_money_transaction,
      amount: -20.to_money(:seu),
      account_balance: -20.to_money(:seu)
    )
  end
  let(:initial_money_transaction_account2_item1) do
    create(
      :money_transaction_item,
      money_transaction: initial_money_transaction,
      account: account2,
      amount: 20.to_money(:seu),
      account_balance: 20.to_money(:seu)
    )
  end

  let(:account1_initial_balance) do
    initial_money_transaction_account1_item1.account_balance
  end
  let(:account2_initial_balance) do
    initial_money_transaction_account2_item1.account_balance
  end

  let(:payment_description) { 'bus fare' }
  let(:payment_amount) { 9 }
  let(:payment_to_acount_reference) { account1.reference }

  let(:expected_account1_pot_payment_balance) do
    account1_initial_balance + payment_amount.to_money(:seu)
  end
  let(:expected_account2_pot_payment_balance) do
    account2_initial_balance - payment_amount.to_money(:seu)
  end

  before do
    account1
    account2
    initial_money_transaction_account1_item1
    initial_money_transaction_account2_item1
  end

  it 'creates money transactions in appropriate accounts' do
    sign_in user2

    visit 'account'

    expect(page).to have_current_path(user_account_root_path)

    expect(page).to have_content('Account Reference')
    expect(page).to have_content(account2.reference)
    expect(page).to have_content('Account Balance')
    expect(page).to have_content(account2_initial_balance)

    expect(page).to have_table(
      'Transactions',
      with_rows: [
        {
          'Ref' => initial_money_transaction.reference,
          'Description' => initial_money_transaction.description,
          'Amount' => initial_money_transaction_account2_item1.amount.format,
          'Balance' => account2_initial_balance.format
        }
      ]
    )

    click_link 'Make a Payment'

    expect(page).to have_text 'New Payment'

    # Submit with invalid payment details
    click_button 'Create payment'

    expect(page).to have_text("can't be blank")

    fill_in 'Description', with: payment_description
    fill_in 'To account reference', with: payment_to_acount_reference
    fill_in 'Amount', with: payment_amount

    click_button 'Create payment'

    expect(page).to have_text 'Payment created'
    expect(page).to have_content('Account Balance')
    expect(page).to have_content(expected_account2_pot_payment_balance)
    expect(page).to have_table(
      'Transactions',
      with_rows: [
        {
          'Ref' => MoneyTransaction.last.reference,
          'Description' => payment_description,
          'Amount' => -payment_amount.to_money(:seu).format,
          'Balance' => expected_account2_pot_payment_balance.format
        },
        {
          'Ref' => initial_money_transaction.reference,
          'Description' => initial_money_transaction.description,
          'Amount' => initial_money_transaction_account2_item1.amount.format,
          'Balance' => account2_initial_balance.format
        }
      ]
    )

    click_link 'Log out'

    expect(page).to have_text 'Signed out successfully.'

    sign_in user1

    visit 'account'

    expect(page).to have_current_path(user_account_root_path)

    expect(page).to have_content('Account Reference')
    expect(page).to have_content(account1.reference)

    expect(page).to have_content('Account Balance')
    expect(page).to have_content(expected_account2_pot_payment_balance)
    expect(page).to have_table(
      'Transactions',
      with_rows: [
        {
          'Ref' => MoneyTransaction.last.reference,
          'Description' => payment_description,
          'Amount' => payment_amount.to_money(:seu).format,
          'Balance' => expected_account1_pot_payment_balance.format
        },
        {
          'Ref' => initial_money_transaction.reference,
          'Description' => initial_money_transaction.description,
          'Amount' => -initial_money_transaction_account1_item1.amount.format,
          'Balance' => -account1_initial_balance.format
        }
      ]
    )
  end
end
