# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :authorize_user_access_to_from_account!

  def new
    @payment = new_payment
  end

  def create
    @payment = build_payment

    if @payment.save
      redirect_to user_account_root_path,
                  notice: I18n.t('payment_successful')
    else
      render 'new'
    end
  end

  private

  def new_payment
    Payment.new(from_account_id: params[:account_id])
  end

  def build_payment
    Payment.new(
      from_account_id: params[:account_id],
      to_account_reference: payment_params[:to_account_reference],
      amount: payment_params[:amount],
      description: payment_params[:description]
    )
  end

  def payment_params
    params.require(:payment).permit(
      :to_account_reference,
      :description,
      :amount
    )
  end

  def from_account
    @from_account ||= Account.find(params[:account_id])
  end

  def authorize_user_access_to_from_account!
    return if from_account.user_id == current_user.id

    head :forbidden
  end
end
