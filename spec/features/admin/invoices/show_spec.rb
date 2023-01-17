require 'rails_helper'

RSpec.describe 'admin invoice #show' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Rays Hand Made Jewlery')
    @merchant2 = Merchant.create!(name: 'Jays Foot Made Jewlery')

    @item1 = Item.create!(name: 'Chips', description: 'Ring', unit_price: 20, merchant_id: @merchant1.id)
    @item2 = Item.create!(name: 'darrel', description: 'Bracelet', unit_price: 40, merchant_id: @merchant1.id)
    @item3 = Item.create!(name: 'don', description: 'Necklace', unit_price: 30, merchant_id: @merchant1.id)

    @item4 = Item.create!(name: 'fake', description: 'Toe Ring', unit_price: 30, merchant_id: @merchant2.id)

    @discount1 = Discount.create!(percentage: 0.2, quantity_threshold: 2, merchant_id: @merchant1.id)
    @discount2 = Discount.create!(percentage: 0.4, quantity_threshold: 4, merchant_id: @merchant1.id)

    @customer1 = Customer.create!(first_name: 'Kyle', last_name: 'Ledin')
    @customer2 = Customer.create!(first_name: 'William', last_name: 'Lampke')

    @invoice1 = Invoice.create!(status: 1, customer_id: @customer1.id)
    @invoice2 = Invoice.create!(status: 1, customer_id: @customer1.id)
    @invoice3 = Invoice.create!(status: 1, customer_id: @customer1.id)

    @invoice4 = Invoice.create!(status: 1, customer_id: @customer2.id)

    @transaction1 = Transaction.create!(credit_card_number: '123456789', credit_card_expiration_date: '05/07',
                                        invoice_id: @invoice1.id)
    @transaction2 = Transaction.create!(credit_card_number: '987654321', credit_card_expiration_date: '04/07',
                                        invoice_id: @invoice2.id)
    @transaction3 = Transaction.create!(credit_card_number: '543219876', credit_card_expiration_date: '03/07',
                                        invoice_id: @invoice3.id)

    @transaction4 = Transaction.create!(credit_card_number: '121987654', credit_card_expiration_date: '02/07',
                                        invoice_id: @invoice4.id)

    @ii1 = InvoiceItem.create!(quantity: 5, unit_price: @item1.unit_price, item_id: @item1.id,
                               invoice_id: @invoice1.id, status: 1)
    @ii2 = InvoiceItem.create!(quantity: 5, unit_price: @item2.unit_price, item_id: @item2.id, invoice_id: @invoice2.id)
    @ii3 = InvoiceItem.create!(quantity: 5, unit_price: @item3.unit_price, item_id: @item3.id, invoice_id: @invoice3.id)
    @ii4 = InvoiceItem.create!(quantity: 5, unit_price: @item4.unit_price, item_id: @item4.id, invoice_id: @invoice4.id)
  end

  describe 'story 33' do
    it 'shows the invoice id' do
      visit "admin/invoices/#{@invoice1.id}"

      expect(page).to have_content(@invoice1.id)
    end
    it 'shows the invoice status' do
      visit "admin/invoices/#{@invoice1.id}"

      expect(page).to have_content(@invoice1.status)
    end

    it 'shows the invoice created_at date' do
      visit "admin/invoices/#{@invoice1.id}"

      expect(page).to have_content(@invoice1.created)
    end
    it 'shows the invoice customer first and last name' do
      visit "admin/invoices/#{@invoice1.id}"

      expect(page).to have_content(@customer1.first_name)
      expect(page).to have_content(@customer1.last_name)
    end
  end

  describe 'User Story 34' do
    it 'shows invoice item info' do
      visit admin_invoice_path(@invoice1)

      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@ii1.quantity)
      expect(page).to have_content(@ii1.unit_price)
      expect(page).to have_content(@ii1.status)
    end
  end

  describe 'story 35' do
    it 'display the total revenue generated from the invoice' do
      ii5 = InvoiceItem.create!(quantity: 10, unit_price: @item4.unit_price, item_id: @item4.id,
                                invoice_id: @invoice1.id)
      visit "admin/invoices/#{@invoice1.id}"

      expect(page).to have_content("$#{@invoice1.total_revenue / 100}")
    end
  end

  describe 'User story 36' do
    it 'updates invoice status' do
      visit "admin/invoices/#{@invoice1.id}"
      select 'completed', from: 'invoice_status'
      click_button 'Update Invoice Status'
      @invoice1.reload
      expect(@invoice1.status).to eq('completed')
    end
  end
  describe 'user story 8' do
    it "Then I see the total revenue from this invoice (not including discounts)
    And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation" do
      visit "admin/invoices/#{@invoice1.id}"
      expect(page).to have_content('Total Revenue: $100.0')
      expect(page).to have_content('Discount: $60.0')
      expect(page).to have_content('Total With Discount: $40.0')
    end
  end
  describe 'us8 additional testing' do
    it 'additional test' do
      invoice5 = @customer1.invoices.create!(status: 1)
      ii5 = InvoiceItem.create!(quantity: 5, unit_price: @item1.unit_price, item_id: @item1.id,
                                invoice_id: invoice5.id)

      ii8 = InvoiceItem.create!(quantity: 4, unit_price: @item2.unit_price, item_id: @item2.id,
                                invoice_id: invoice5.id)
      visit "admin/invoices/#{invoice5.id}"
      expect(page).to have_content('Total Revenue: $260.0')
      expect(page).to have_content('Discount: $156.0')
      expect(page).to have_content('Total With Discount: $104.0')
      
    end
  end
end
