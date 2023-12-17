# frozen_string_literal: true

class MoneyTransactionItem < ApplicationRecord
  belongs_to :money_transaction
  belongs_to :account
  belongs_to :next_account_item,
             class_name: 'MoneyTransactionItem',
             optional: true

  monetize :amount_cents, with_currency: :seu
  monetize :account_balance_cents, with_currency: :seu
end
