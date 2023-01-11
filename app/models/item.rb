class Item < ApplicationRecord 
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def top_sales_date
    invoices
      .joins(:transactions)
      .where("transactions.result = ?", 1)
      .select("
        sum(invoice_items.quantity*invoice_items.unit_price) as revenue,
        DATE_TRUNC('day', invoices.created_at) as day
        ")
      .group(:day)
      .order(revenue: :desc, day: :desc)
      .first
      .day
      .to_date
  end
end
