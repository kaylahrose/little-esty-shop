class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  enum status: ["pending", "packaged", "shipped"]

  def item_name
    Item.find(self.item_id).name
  end
end