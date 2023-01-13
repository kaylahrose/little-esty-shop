class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  enum status: ["pending", "packaged", "shipped"]


  def item_name
    Item.find(self.item_id).name
  end

end