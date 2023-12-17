# frozen_string_literal: true

class CreateMoneyTransactionItems < ActiveRecord::Migration[7.1]
  def change
    create_table :money_transaction_items do |t|
      t.references :money_transaction, null: false, foreign_key: true, index: true
      t.references :account, null: false, foreign_key: true, index: true
      t.references :next_account_item, null: true, index: true
      t.datetime :next_account_item_created_at

      t.timestamps
    end

    add_foreign_key :money_transaction_items,
                    :money_transaction_items,
                    column: :next_account_item_id
  end
end
