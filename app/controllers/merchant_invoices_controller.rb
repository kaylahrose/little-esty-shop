class MerchantInvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @invoice = Invoice.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    invoice = Invoice.find(params[:id])
    item = Item.find(params[:item_id])
    item.update(status: params[:status])
    redirect_to "/merchant/#{merchant.id}/invoices/#{invoice.id}"
  end
end