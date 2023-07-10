# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Оплата наших услуг
class PaymentsController < ApplicationController
  layout 'payment'

  skip_before_action :verify_authenticity_token, only: [:post3ds]

  def new
    if invoice.fully_paid?
      redirect_to invoice_path(invoice)
    else
      render locals: {
        form: CloudPaymentsForm.new,
        invoice:
      }
    end
  end

  # TODO: Можно создавтаь OpenbillCharge и записывать туда результаты
  # см пример: app/modules/cloud_payments/recurrent_payment.rb
  def create
    unless form.valid?
      render :new, locals: { form:, invoice: }
      return
    end

    transaction = CloudPayments.client.payments.cards.charge(
      name: invoice.title,
      card_cryptogram_packet: form.cryptogram_packet,
      ip_address: request.remote_ip,
      amount: invoice.amount.to_f,
      currency: 'RUB',
      account_id: invoice.account_id,
      description: invoice.description,
      invoice_id: invoice.id
    )

    if transaction.required_secure3d? # CloudPayments::Secure3D
      logger.info "REQUIRE_3DS: transaction_id=#{transaction.try(:transaction_id)}"
      render :form3ds,
             locals: { resp: transaction, term_url: post3ds_payment_url(invoice_id, recurrent: form.recurrent) },
             layout: false
      return
    end

    create_payment invoice, transaction
    save_card transaction if form.recurrent?
    redirect_to account_path(transaction_params: params), notice: t('flashes.paid', amount: invoice.amount)
  rescue CloudPayments::Client::ReasonedGatewayError, ActiveRecord::ActiveRecordError => e
    Bugsnag.notify e
    logger.error e
    flash.now[:error] = e.message

    render 'new', locals: { form:, invoice: }
  end

  def post3ds
    # Возвращает CloudPayments::Transaction
    transaction = CloudPayments.client.payments.post3ds(*params.require(%i[MD PaRes]))

    logger.info "POST3DS: invoice_id=#{invoice_id}; #{transaction.try(:card_holder_message)}"

    create_payment invoice, transaction
    save_card transaction if params[:recurrent].to_s == 'true'

    redirect_to account_path(transaction_params: params), notice: t('flashes.paid', amount: invoice.amount)
  rescue CloudPayments::Client::ReasonedGatewayError, CloudPayments::Client::GatewayErrors::IncorrectCVV, ActiveRecord::ActiveRecordError => e
    Bugsnag.notify e
    flash.now[:error] = e.message

    render 'new', locals: { form: CloudPaymentsForm.new, invoice: }
  end

  private

  def create_payment(_invoice, transaction)
    logger.info "Payment: invoice_id=#{invoice_id}; #{transaction}"
    # Продвинуть тариф проектов
    # Billing::IncomeFromCloudPayments.perform transaction
  end

  def form
    @form ||= CloudPaymentsForm.new permitted_params.to_h
  end

  def invoice_id
    params.require(:id)
  end

  def invoice
    @invoice ||= Invoice.find(invoice_id)
  end

  def save_card(transaction)
    current_user.payment_cards.create!(**transaction)
  end

  def permitted_params
    params.fetch(:cloud_payments_form, {}).permit :recurrent, :cryptogram_packet, :name
  end

  def logger
    @logger ||= ActiveSupport::Logger.new(Rails.root.join('log/payments.log'))
  end
end
