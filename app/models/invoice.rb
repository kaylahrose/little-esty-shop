class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

  enum status: ['cancelled', 'in progress', 'completed']

  def self.incomplete
    joins(:invoice_items).where('invoice_items.status != 2').distinct.order(:created_at)
  end

  def created
    created_at.strftime('%A, %B %-d, %Y')
  end

  def successful?
    transactions.pluck(:result).include?('success')
  end

  def total_revenue
    return 0 unless successful?

    invoice_items
      .sum('quantity * unit_price')
  end

  def self.merchant_ii(merchant_id, invoice_id)
    InvoiceItem.joins(:item)
    .where("items.merchant_id = #{merchant_id} AND invoice_items.invoice_id = #{invoice_id}")
  end
  def discounted_revenue(merchant_id)
    invoice_items
    .joins(item: {merchant: :discounts})
    .where("invoice_items.quantity >= discounts.quantity_threshold AND items.merchant_id = #{merchant_id}")
    .distinct
    .sum('invoice_items.quantity * invoice_items.unit_price * discounts.percentage')
  end
  def total_minus_discounted_revenue(merchant_id)
    Merchant.total_invoice_revenue(id).to_f - discounted_revenue(merchant_id)
  end
end
