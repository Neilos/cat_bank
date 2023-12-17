# frozen_string_literal: true

class AccountsController < ApplicationController
  def show
    @account = account
    @money_transaction_items = MoneyTransactionItem
                               .where(account: @account)
                               .joins(:money_transaction)
                               .eager_load(:money_transaction)
                               .order(id: :desc)
                               .page params[:page]
  end

  private

  def account
    existing_account || new_account
  end

  def existing_account
    Account.find_by(user: current_user)
  end

  def new_account
    Account.create(user: current_user)
  end
end
