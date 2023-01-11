class InvoicesController < ApplicationController
  def show; end

  def update
    invoice = Invoice.find(params[:id])
    invoice.update(invoice_params)
  end

  private

  def invoice_params
    params.require(:invoice).permit(:status)
  end
end
