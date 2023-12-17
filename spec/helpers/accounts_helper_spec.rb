# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsHelper do
  describe 'account_balance' do
    subject(:account_balance) { helper.account_balance(money_transaction_item) }

    context 'with nil money_transaction_item' do
      let(:money_transaction_item) { nil }

      it 'returns formatted zero in seu currency' do
        expect(account_balance).to eq(0.to_money(:seu).format)
      end
    end

    context 'with a money_transaction_item' do
      let(:money_transaction_item) do
        create(
          :money_transaction_item,
          amount: 5.to_money(:seu),
          account_balance: 24.to_money(:seu)
        )
      end

      it 'is the formatted account_balance of the first money_transaction_item' do
        expect(account_balance).to eq(24.to_money(:seu).format)
      end
    end
  end
end
