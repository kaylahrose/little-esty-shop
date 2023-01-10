class MerchantInvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @invoice = Invoice.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

   def update
    invoice_item = InvoiceItem.find(params[:ii_id])
    invoice_item.update(status: params[:status].to_i)
    redirect_to "/merchant/#{params[:merchant_id]}/invoices/#{params[:id]}"
  end
end