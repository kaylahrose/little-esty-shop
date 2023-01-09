class Admin::InvoicesController < ApplicationController
  def index
        render plain: "admin invoice"

  end

  def show
    @invoice = Invoice.find(params[:id])
  end
end