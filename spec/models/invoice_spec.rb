require 'rails_helper'

RSpec.describe Invoice do
  before :each do
    FactoryBot.reload
  end

  describe 'Relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end

  describe 'class methods' do
    describe '#incomplete' do
      it "returns invoices with items that haven't yet shipped" do
        pending_invoice  = FactoryBot.create(:invoice_with_invoice_item, invoice_item_status: 0)
        packaged_invoice = FactoryBot.create(:invoice_with_invoice_item, invoice_item_status: 1)
        shipped_invoice  = FactoryBot.create(:invoice_with_invoice_item, invoice_item_status: 2)

        expect(Invoice.incomplete).to include(pending_invoice)
        expect(Invoice.incomplete).to include(packaged_invoice)
        expect(Invoice.incomplete).to_not include(shipped_invoice)
      end
    end

    describe '#merchant_ii' do
      it 'gets a merchants invoice items' do
        @merchant1 = Merchant.create!(name: 'Rays Hand Made Jewlery')
        @item1 = @merchant1.items.create!(name: 'Chips', description: 'Ring', unit_price: 20)
        @item2 = @merchant1.items.create!(name: 'darrel', description: 'Bracelet', unit_price: 40)
        @customer1 = Customer.create!(first_name: 'Kyle', last_name: 'Ledin')
        @invoice1 = @customer1.invoices.create!(status: 1)
        @transaction1 = @invoice1.transactions.create!(credit_card_number: '123456789',
                                                       credit_card_expiration_date: '05/07')
        @ii1 = InvoiceItem.create!(quantity: 5, unit_price: @item1.unit_price, item_id: @item1.id,
                                   invoice_id: @invoice1.id)
        @ii6 = InvoiceItem.create!(quantity: 10, unit_price: @item2.unit_price, item_id: @item2.id,
                                   invoice_id: @invoice1.id)

        expect(Invoice.merchant_ii(@merchant1.id, @invoice1.id)).to eq([@ii1, @ii6])
      end
    end
  end

  describe 'instance methods' do
    describe '.created' do
      it 'returns created_at in a readable format' do
        invoice = FactoryBot.create(:invoice, created_at: Time.new(1963, 11, 23))

        expect(invoice.created).to eq('Saturday, November 23, 1963')
      end
    end

    describe '.successful?' do
      it 'figures out if invoice has had at least 1 successful transaction' do
        invoice = FactoryBot.create(:invoice_with_transaction, transaction_result: 0)

        expect(invoice.successful?).to be false

        invoice.transactions << FactoryBot.create(:transaction, result: 1)

        expect(invoice.successful?).to be true
      end
    end
  end

  describe '.total_revenue' do
    it 'totals the revenue for all items on the invoice' do
      @merchant1 = Merchant.create!(name: 'Rays Hand Made Jewlery')
      @item1 = Item.create!(name: 'Chips', description: 'Ring', unit_price: 20, merchant_id: @merchant1.id)
      @merchant2 = Merchant.create!(name: 'Jays Foot Made Jewlery')
      @customer1 = Customer.create!(first_name: 'Kyle', last_name: 'Ledin')
      @item4 = Item.create!(name: 'fake', description: 'Toe Ring', unit_price: 30, merchant_id: @merchant2.id)
      @invoice1 = Invoice.create!(status: 1, customer_id: @customer1.id)
      @transaction1 = Transaction.create!(credit_card_number: '123456789', credit_card_expiration_date: '05/07',
                                          invoice_id: @invoice1.id)
      @ii1 = InvoiceItem.create!(quantity: 5, unit_price: @item1.unit_price, item_id: @item1.id,
                                 invoice_id: @invoice1.id)
      @ii5 = InvoiceItem.create!(quantity: 10, unit_price: @item4.unit_price, item_id: @item4.id,
                                 invoice_id: @invoice1.id)

      expect(@invoice1.total_revenue).to eq(400)
    end
    describe "#discounted_revenue AND #total_minus_discounted_revenue" do
      it "totals merchant based on quantity threshold requirements" do
      @merchant1 = Merchant.create!(name: 'Rays Hand Made Jewlery')
      @item1 = Item.create!(name: 'Chips', description: 'Ring', unit_price: 20, merchant_id: @merchant1.id)
      @item2 = @merchant1.items.create!(name: 'darrel', description: 'Bracelet', unit_price: 40)
      @discount1 = Discount.create!(percentage: 0.2, quantity_threshold: 2, merchant_id: @merchant1.id)
      @discount2 = Discount.create!(percentage: 0.4, quantity_threshold: 4, merchant_id: @merchant1.id)
      @customer1 = Customer.create!(first_name: 'Kyle', last_name: 'Ledin')
      invoice5 = @customer1.invoices.create!(status: 1)
      ii5 = InvoiceItem.create!(quantity: 5, unit_price: @item1.unit_price, item_id: @item1.id,
        invoice_id: invoice5.id)
      ii8 = InvoiceItem.create!(quantity: 4, unit_price: @item2.unit_price, item_id: @item2.id,
        invoice_id: invoice5.id)
        expect(invoice5.discounted_revenue(@merchant1.id)).to eq(156.0)
        expect(invoice5.total_minus_discounted_revenue(@merchant1.id)).to eq(104.0)
      end
    end
  end
  describe "#discount_amount AND #total_minus_discount" do
    it "finds a total including the discount" do
      @merchant1 = Merchant.create!(name: 'Rays Hand Made Jewlery')
      @item1 = Item.create!(name: 'Chips', description: 'Ring', unit_price: 20, merchant_id: @merchant1.id)
      @item2 = @merchant1.items.create!(name: 'darrel', description: 'Bracelet', unit_price: 40)
      @discount1 = Discount.create!(percentage: 0.2, quantity_threshold: 2, merchant_id: @merchant1.id)
      @discount2 = Discount.create!(percentage: 0.4, quantity_threshold: 4, merchant_id: @merchant1.id)
      @customer1 = Customer.create!(first_name: 'Kyle', last_name: 'Ledin')
      invoice5 = @customer1.invoices.create!(status: 1)
      ii5 = InvoiceItem.create!(quantity: 5, unit_price: @item1.unit_price, item_id: @item1.id,
        invoice_id: invoice5.id)
      ii8 = InvoiceItem.create!(quantity: 4, unit_price: @item2.unit_price, item_id: @item2.id,
        invoice_id: invoice5.id)
        
        expect(invoice5.discount_amount).to eq(156.0)
        expect(invoice5.total_minus_discount).to eq(104.0)
    end
  end
end
