class AdminController < ApplicationController
  def index
    @top_customers = Customer.top_customers
    @incomplete_invoices = Invoice.incomplete
    render plain: "admin controller connected"
  end
end