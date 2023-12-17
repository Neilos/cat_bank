# frozen_string_literal: true

class AddAmountToMoneyTransactionItems < ActiveRecord::Migration[7.1]
  def change
    change_table :money_transaction_items do |t|
      t.monetize :amount, currency: { present: false }
    end
  end
end
