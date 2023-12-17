# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# accounts
system_account = FactoryBot.create(:account)
user_account1 = FactoryBot.create(:account)
FactoryBot.create(:account)

# money_transactions
money_transaction1 = FactoryBot.create(
  :money_transaction,
  description: 'opening balance',
  created_at: 2.days.ago
)
money_transaction2 = FactoryBot.create(
  :money_transaction,
  description: 'fee',
  created_at: 1.day.ago
)

# system_account money_transaction_items
FactoryBot.create(
  :money_transaction_item,
  account: system_account,
  money_transaction: money_transaction1,
  amount: -16.to_money(:seu),
  account_balance: -16.to_money(:seu)
)
FactoryBot.create(
  :money_transaction_item,
  account: system_account,
  money_transaction: money_transaction2,
  amount: 2.to_money(:seu),
  account_balance: -14.to_money(:seu)
)

# user_account1 money_transaction_items
FactoryBot.create(
  :money_transaction_item,
  money_transaction: money_transaction1,
  account: user_account1,
  amount: 10.to_money(:seu),
  account_balance: 10.to_money(:seu)
)
FactoryBot.create(
  :money_transaction_item,
  account: user_account1,
  money_transaction: money_transaction1,
  amount: 6.to_money(:seu),
  account_balance: 16.to_money(:seu)
)
FactoryBot.create(
  :money_transaction_item,
  money_transaction: money_transaction2,
  account: user_account1,
  amount: -2.to_money(:seu),
  account_balance: 14.to_money(:seu)
)
