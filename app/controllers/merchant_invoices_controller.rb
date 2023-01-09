class MerchantInvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
        render plain: "merchant controller connected"

  end

  def show
    @invoice = Invoice.find(params[:id])
        render plain: "merchant controller show"

  end
end