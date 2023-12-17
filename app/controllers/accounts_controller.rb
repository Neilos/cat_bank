# frozen_string_literal: true

class AccountsController < ApplicationController
  def show
    @account = Account.find(params[:id])
    @money_transaction_items = MoneyTransactionItem
                               .where(account: @account)
                               .order(id: :desc)
  end
end
