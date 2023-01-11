require 'rails_helper'

RSpec.describe Item do
  describe 'Relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'instance methods' do
    describe '#top_sales_date' do
      it 'returns the top sales date for a merchant' do
        mariah = Merchant.create!(name: 'Mariah Ahmed')
        customer = FactoryBot.create(:customer)
        item = Item.create!(merchant_id: mariah.id)
        3.times { Invoice.create!(created_at: Time.now - 1.days, customer_id: customer.id) }
        4.times { Invoice.create!(created_at: Time.now - 3.days, customer_id: customer.id) }
        6.times { Invoice.create!(created_at: Time.now - 9.days, customer_id: customer.id) }

        Invoice.all.each do |invoice|
          FactoryBot.create(:transaction, invoice_id: invoice.id, result: 1)
          FactoryBot.create(:invoice_item, invoice_id: invoice.id, item_id: item.id, quantity: 1, unit_price: 1)
        end

        expect(item.top_sales_date).to eq((Invoice.last.created_at).to_date)
      end
    end
  end
end
