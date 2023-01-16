# When I visit my merchant's invoice show page(/merchants/merchant_id/invoices/invoice_id)
# Then I see information related to that invoice including:

# Invoice id
# Invoice status
# Invoice created_at date in the format "Monday, July 18, 2019"
# Customer first and last name

require 'rails_helper'

RSpec.describe 'Merchant invoice show page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Rays Hand Made Jewlery')
    @merchant2 = Merchant.create!(name: 'Jays Foot Made Jewlery')

    @item1 = @merchant1.items.create!(name: 'Chips', description: 'Ring', unit_price: 20)
    @item2 = @merchant1.items.create!(name: 'darrel', description: 'Bracelet', unit_price: 40)
    @item3 = @merchant1.items.create!(name: 'don', description: 'Necklace', unit_price: 30)
    @item4 = @merchant2.items.create!(name: 'fake', description: 'Toe Ring', unit_price: 30)

    @discount1 = Discount.create!(percentage: 0.2, quantity_threshold: 2, merchant_id: @merchant1.id)
    @discount2 = Discount.create!(percentage: 0.4, quantity_threshold: 4, merchant_id: @merchant1.id)

    @customer1 = Customer.create!(first_name: 'Kyle', last_name: 'Ledin')
    @customer2 = Customer.create!(first_name: 'William', last_name: 'Lampke')

    @invoice1 = @customer1.invoices.create!(status: 1)
    @invoice2 = @customer1.invoices.create!(status: 1)
    @invoice3 = @customer1.invoices.create!(status: 1)
    @invoice4 = @customer2.invoices.create!(status: 1)

    @transaction1 = @invoice1.transactions.create!(credit_card_number: '123456789',
                                                   credit_card_expiration_date: '05/07')
    @transaction2 = @invoice2.transactions.create!(credit_card_number: '987654321',
                                                   credit_card_expiration_date: '04/07')
    @transaction3 = @invoice3.transactions.create!(credit_card_number: '543219876',
                                                   credit_card_expiration_date: '03/07')
    @transaction4 = @invoice4.transactions.create!(credit_card_number: '121987654',
                                                   credit_card_expiration_date: '02/07')

    @ii1 = InvoiceItem.create!(quantity: 5, unit_price: @item1.unit_price, item_id: @item1.id,
                               invoice_id: @invoice1.id, status: 1)
    @ii2 = InvoiceItem.create!(quantity: 10, unit_price: @item2.unit_price, item_id: @item2.id,
                               invoice_id: @invoice2.id)
    @ii3 = InvoiceItem.create!(quantity: 5, unit_price: @item3.unit_price, item_id: @item3.id, invoice_id: @invoice3.id)
    @ii4 = InvoiceItem.create!(quantity: 5, unit_price: @item4.unit_price, item_id: @item4.id, invoice_id: @invoice4.id)
  end

  it 'lists invoices attributes' do
    visit merchant_invoice_path(@merchant1, @invoice1)

    expect(page).to have_content(@invoice1.id)
    expect(page).to have_content(@invoice1.status)
    expect(page).to have_content(@invoice1.created_at.strftime('%A, %B %e, %Y'))
    expect(page).to have_content(@customer1.first_name)
    expect(page).to have_content(@customer1.last_name)
  end

  describe 'total revenue (userstory 17)' do
    it "As a merchant
      When I visit my merchant invoice show page
      Then I see the total revenue that will be generated from all of my items on the invoice" do
      item5 = @merchant1.items.create!(name: 'food1', description: 'a', unit_price: 10)
      item6 = @merchant1.items.create!(name: 'food2', description: 'b', unit_price: 5)

      ii5 = InvoiceItem.create!(quantity: 5, unit_price: 10, item_id: item5.id, invoice_id: @invoice1.id)
      ii6 = InvoiceItem.create!(quantity: 5, unit_price: 5, item_id: item6.id, invoice_id: @invoice1.id)

      visit "/merchant/#{@merchant1.id}/invoices/#{@invoice1.id}"
      expect(page).to have_content('Total Revenue: 175')
    end
  end

  describe 'story 18' do
    #     As a merchant
    # When I visit my merchant invoice show page
    # I see that each invoice item status is a select field
    # And I see that the invoice item's current status is selected
    # When I click this select field,
    # Then I can select a new status for the Item,
    # And next to the select field I see a button to "Update Item Status"
    # When I click this button
    # I am taken back to the merchant invoice show page
    it 'Has a select field for item status' do
      visit "/merchant/#{@merchant1.id}/invoices/#{@invoice1.id}"
      expect(page).to have_content('packaged')
    end
    it 'clicking update refreshes the page and updates the item status' do
      visit "/merchant/#{@merchant1.id}/invoices/#{@invoice1.id}"

      expect(page).to have_content('packaged')
      select 'packaged'
      expect(page).to have_content('pending')

      click_on 'Update Item Status'

      expect(page).to have_content('pending')
    end
  end

  describe 'story 16' do
    it 'shows all items on the invoice' do
      ii5 = InvoiceItem.create!(quantity: 5, unit_price: @item4.unit_price, item_id: @item4.id,
                                invoice_id: @invoice1.id)
      ii6 = InvoiceItem.create!(quantity: 10, unit_price: @item2.unit_price, item_id: @item2.id,
                                invoice_id: @invoice1.id)
      visit "/merchant/#{@merchant1.id}/invoices/#{@invoice1.id}"

      expect(page).to have_content(@item1.name)
    end

    it 'shows items name, quantity of item ordered, price item sold for, invoice item status' do
      visit "/merchant/#{@merchant1.id}/invoices/#{@invoice1.id}"

      expect(page).to have_content(@ii1.quantity)
      expect(page).to have_content(@ii1.unit_price)
      expect(page).to have_content(@ii1.status)
    end

    it 'does not show any information from other merchants' do
      visit "/merchant/#{@merchant1.id}/invoices/#{@invoice1.id}"

      expect(page).to_not have_content(@item4.name)
    end
  end
  describe 'total discounted revenue' do
    it "When I visit my merchant invoice show page
  Then I see the total revenue for my merchant from this invoice (not including discounts)
  And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation" do
      # total revenue [x]
      # total discounted revenue [x]

      visit "/merchant/#{@merchant1.id}/invoices/#{@invoice1.id}"
      expect(page).to have_content('60.0')
    end
    describe 'additional testing' do
      it 'additional testing' do
        invoice5 = @customer1.invoices.create!(status: 1)

        ii5 = InvoiceItem.create!(quantity: 5, unit_price: @item1.unit_price, item_id: @item1.id,
                                  invoice_id: invoice5.id)

        ii8 = InvoiceItem.create!(quantity: 4, unit_price: @item2.unit_price, item_id: @item2.id,
                                  invoice_id: invoice5.id)

        visit "/merchant/#{@merchant1.id}/invoices/#{invoice5.id}"

        expect(page).to have_content("Total Revenue: 260.0")
        expect(page).to have_content("Discount: 156.0")
        expect(page).to have_content("Total With Discount: 104.0")  
      end
    end
  end
end
