# frozen_string_literal: true

FactoryBot.define do
  factory :money_transaction_item do
    money_transaction
    account
    next_account_item_id { nil }
    next_account_item_created_at { nil }
  end
end
