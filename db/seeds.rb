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

# users
user1 = FactoryBot.create(
  :user,
  email: 'rich@example.com',
  password: 'Password123!!',
  password_confirmation: 'Password123!!'
)
user2 = FactoryBot.create(
  :user,
  email: 'poor@example.com',
  password: 'Password123!!',
  password_confirmation: 'Password123!!'
)

# accounts
system_account = FactoryBot.create(
  :account,
  user: nil, # The system account doesn't belong to any user
  reference: '4605e852-61b3-47da-9de5-8068fa7172ac'
)
user_account1 = FactoryBot.create(
  :account,
  user: user1,
  reference: '0f85a4fb-0f5e-479e-898b-b57866b08b9e'
)
user_account2 = FactoryBot.create(
  :account,
  user: user2,
  reference: 'c3c7f394-3569-4c95-b4ab-9232e21079dc'
)

# money_transactions
money_transaction1 = FactoryBot.create(
  :money_transaction,
  description: 'sign up award',
  created_at: 2.days.ago
)
money_transaction2 = FactoryBot.create(
  :money_transaction,
  description: 'fee',
  created_at: 1.day.ago
)
money_transaction3 = FactoryBot.create(
  :money_transaction,
  description: 'sign up award',
  created_at: 1.day.ago
)

# system_account money_transaction_items
FactoryBot.create(
  :money_transaction_item,
  account: system_account,
  money_transaction: money_transaction1,
  amount: -100.to_money(:seu),
  account_balance: -100.to_money(:seu)
)
FactoryBot.create(
  :money_transaction_item,
  account: system_account,
  money_transaction: money_transaction2,
  amount: 2.to_money(:seu),
  account_balance: -98.to_money(:seu)
)
FactoryBot.create(
  :money_transaction_item,
  account: system_account,
  money_transaction: money_transaction3,
  amount: -100.to_money(:seu),
  account_balance: -100.to_money(:seu)
)

# user_account1 money_transaction_items
FactoryBot.create(
  :money_transaction_item,
  money_transaction: money_transaction1,
  account: user_account1,
  amount: 100.to_money(:seu),
  account_balance: 100.to_money(:seu)
)
FactoryBot.create(
  :money_transaction_item,
  money_transaction: money_transaction2,
  account: user_account1,
  amount: -2.to_money(:seu),
  account_balance: 98.to_money(:seu)
)
FactoryBot.create(
  :money_transaction_item,
  money_transaction: money_transaction3,
  account: user_account2,
  amount: 100.to_money(:seu),
  account_balance: 100.to_money(:seu)
)
