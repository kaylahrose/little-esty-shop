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
end