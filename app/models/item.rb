class Item < ApplicationRecord 
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def top_sales_date
    require 'pry'; binding.pry
    invoices
      .joins(:transactions)
      .where("transaction.result = ?", 1)
      .select('invoices.created_at, sum(invoice_items.quantity) as invoice_item_count')
      .group(:id)
      .order('invoice_item_count desc')
      .first
      .created_at
  end
end
