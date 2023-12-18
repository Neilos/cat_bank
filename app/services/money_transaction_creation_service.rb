# frozen_string_literal: true

class MoneyTransactionCreationService
  UnbalancedMoneyTransaction = Class.new(RuntimeError)

  class << self
    def call(...)
      new(...).call
    end
  end

  def call
    lock_accounts!
    create_money_transaction
    release_account_locks!

    true
  end

  private

  attr_reader :description, :money_transaction_items_attributes, :account_ids

  def initialize(description:, money_transaction_items_attributes:)
    @description = description
    @money_transaction_items_attributes = money_transaction_items_attributes
    @account_ids = money_transaction_items_attributes
                   .pluck(:account_id)
                   .uniq
                   .map(&:to_s) # Ssometimes integers and sometimes strings
                   .sort

    ensure_money_transaction_items_sum_to_zero!
  end

  def ensure_money_transaction_items_sum_to_zero!
    return if sum_of_transaction_amounts.zero?

    raise UnbalancedMoneyTransaction,
          'MoneyTransactionItem amounts must sum to zero'
  end

  def sum_of_transaction_amounts
    money_transaction_items_attributes.sum { |attrs| attrs[:amount] }
  end

  def create_money_transaction
    # "Read Committed" is default isolation level for postgresql
    # which is what we want.
    ActiveRecord::Base.transaction do
      money_transaction = MoneyTransaction.create!(description:)

      money_transaction_items_attributes.each do |item_attributes|
        insert_money_transaction_item(
          money_transaction: money_transaction,
          account_id: item_attributes[:account_id],
          amount: item_attributes[:amount]
        )
      end
    end
  end

  def lock_accounts!
    accounts.each(&:lock!)
  end

  def release_account_locks!
    accounts.each { |account| account.update!(updated_at: Time.current) }
  end

  def accounts
    # Order must be consistent to avoid deadlocks between threads
    @accounts ||= Account.where(id: account_ids).order(id: :asc)
  end

  # rubocop:disable Metrics/MethodLength
  def insert_money_transaction_item(money_transaction:, account_id:, amount:)
    previous_account_item = previous_item_for(account_id)

    next_item = MoneyTransactionItem.create!(
      account_id: account_id,
      amount: amount,
      account_balance: new_account_balance(previous_account_item, amount),
      money_transaction: money_transaction
    )

    previous_account_item&.update!(
      next_account_item_id: next_item.id,
      next_account_item_created_at: next_item.created_at
    )
  end
  # rubocop:enable Metrics/MethodLength

  def previous_item_for(account_id)
    MoneyTransactionItem.where(
      account_id:,
      next_account_item: nil
    ).first
  end

  def new_account_balance(previous_account_item, new_amount)
    [previous_account_item&.account_balance, new_amount].compact.sum
  end
end
