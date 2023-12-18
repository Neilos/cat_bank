# frozen_string_literal: true

class Payment
  include ActiveModel::Model

  attr_accessor :from_account_id, :to_account_reference, :amount, :description

  validates :from_account_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :to_account_reference, presence: true
  validate :to_account_reference_must_be_a_valid_account_reference

  def save
    return false unless valid?

    create_money_transaction
  end

  private

  def to_account_reference_must_be_a_valid_account_reference
    return if to_account

    errors.add(:to_account_reference, 'must be a valid account reference')
  end

  def to_account
    Account.find_by(reference: to_account_reference)
  end

  def create_money_transaction
    MoneyTransactionCreationService.call(
      description:,
      money_transaction_items_attributes: [
        { account_id: from_account_id, amount: -amount.to_money(:seu) },
        { account_id: to_account.id, amount: amount.to_money(:seu) }
      ]
    )
  end
end
