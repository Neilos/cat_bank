# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :ensure_user_account_is_setup

  def show
    @account = account
    @money_transaction_items = MoneyTransactionItem
                               .where(account: @account)
                               .joins(:money_transaction)
                               .eager_load(:money_transaction)
                               .order(id: :desc)
                               .page params[:page]

    flash.now[:notice] = I18n.t('new_sign_up_award') if new_user?
  end

  private

  def account
    existing_user_account || new_account
  end

  def new_user?
    existing_user_account.blank?
  end

  def existing_user_account
    return @existing_user_account if defined?(@existing_user_account)

    @existing_user_account = Account.find_by(user: current_user)
  end

  def ensure_user_account_is_setup
    return unless new_user?

    MoneyTransactionCreationService.call(
      description: 'New signup award',
      money_transaction_items_attributes: [
        { account_id: system_account.id, amount: -award_amount.to_money(:seu) },
        { account_id: new_account.id, amount: award_amount.to_money(:seu) }
      ]
    )
  end

  def system_account
    Account.where(user: nil).sole
  end

  def new_account
    @new_account ||= Account.create(user: current_user)
  end

  def award_amount
    100.to_money(:seu)
  end
end
