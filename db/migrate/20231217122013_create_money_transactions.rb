# frozen_string_literal: true

class CreateMoneyTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :money_transactions do |t|
      t.uuid :reference, default: 'gen_random_uuid()'
      t.string :description, null: false

      t.index :reference, unique: true

      t.timestamps
    end
  end
end
