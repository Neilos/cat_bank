# frozen_string_literal: true

module AccountsHelper
  def account_balance(money_transaction_item)
    return 0.to_money(:seu).format unless money_transaction_item

    money_transaction_item.account_balance.format
  end
end
