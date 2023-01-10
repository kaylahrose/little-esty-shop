class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: ["cancelled", "in progress", "completed" ]

  def self.incomplete
    joins(:invoice_items).where("invoice_items.status != 2").distinct.order(:created_at)
  end

  def created
    created_at.strftime("%A, %B %-d, %Y")
  end

  def successful?
    transactions.pluck(:result).include?("success")
  end

  def total_revenue
  return 0 if !self.successful?
  invoice_items.sum do |invoice_item|
      invoice_item.quantity * invoice_item.unit_price
    end
  end
end