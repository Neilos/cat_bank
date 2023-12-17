# frozen_string_literal: true

class AccountsController < ApplicationController
  def show
    @account = Account.find(params[:id])
    @money_transaction_items = MoneyTransactionItem
                               .where(account: @account)
                               .joins(:money_transaction)
                               .eager_load(:money_transaction)
                               .order(id: :desc)
                               .page params[:page]
  end
end
