# frozen_string_literal: true

class AddAccountBalanceToMoneyTransactionItem < ActiveRecord::Migration[7.1]
  def change
    change_table :money_transaction_items do |t|
      t.monetize :account_balance, currency: { present: false }
    end
  end
end
