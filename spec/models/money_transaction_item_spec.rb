# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoneyTransactionItem do
  describe 'associations' do
    subject(:model) { described_class.new }

    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:money_transaction) }

    it 'belongs to next_account_item' do
      expect(model).to(
        belong_to(:next_account_item)
          .class_name(described_class.name)
          .optional
      )
    end
  end

  describe 'amount' do
    it { is_expected.to monetize(:amount).with_currency(:seu) }
  end

  describe 'account_balance' do
    it { is_expected.to monetize(:account_balance).with_currency(:seu) }
  end
end
