require 'rails_helper'

RSpec.describe InvoiceItem do
  describe "Relationships" do
    it {should belong_to :invoice} 
    it {should belong_to :item} 
  end

  describe '.item_name' do
    it 'returns the name of the associated item' do
      invoice_item = FactoryBot.create(:invoice_item)

      expect(invoice_item.item_name).to eq("Item0")
    end
  end
  describe "#my_discounts" do
    it "for each bulk discount that was applied" do
      @merchant1 = Merchant.create!(name: 'Rays Hand Made Jewlery')
      @item1 = Item.create!(name: 'Chips', description: 'Ring', unit_price: 20, merchant_id: @merchant1.id)
      @discount1 = Discount.create!(percentage: 0.2, quantity_threshold: 2, merchant_id: @merchant1.id)
      @discount2 = Discount.create!(percentage: 0.4, quantity_threshold: 4, merchant_id: @merchant1.id)
      @customer1 = Customer.create!(first_name: 'Kyle', last_name: 'Ledin')
      invoice5 = @customer1.invoices.create!(status: 1)
      ii5 = InvoiceItem.create!(quantity: 5, unit_price: @item1.unit_price, item_id: @item1.id,
        invoice_id: invoice5.id)
      expect(ii5.my_discounts).to eq([@discount1, @discount2])
    end
  end
end