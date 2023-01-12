require 'rails_helper'

RSpec.describe 'admin index page' do
  before :each do
    FactoryBot.reload
    @customers = FactoryBot.create_list(:customer_with_invoice, 10)
    @invoices = Invoice.all
  end
  
  describe 'header' do
    it 'indicates we are on admin dashboard with header' do
      visit admin_index_path
      within('header.flex-container') do
        expect(page).to have_content('Admin Dashboard')
      end
    end

    it 'has links to admin merchants and admin invoices' do
      visit admin_index_path

      within('header.flex-container') do
        expect(page).to have_link('Merchants', href: admin_merchants_path)
        expect(page).to have_link('Invoices', href: admin_invoices_path)
      end
    end

    xit 'lists contributors' do
      json_response = File.open("fixtures/kr_gh_api_response.json")
      WebMock.stub_request(:get, 'https://api.github.com/repos/kaylahrose/little-esty-shop').
        to_return(status: 200, body: json_response)
      
      visit admin_index_path

      within('header.github-flex') do
        expect(page).to have_link("Merchants", href: admin_merchants_path)
        expect(page).to have_link("Invoices", href: admin_invoices_path)
      end
    end
  end

  describe 'top customers' do
    it 'lists the top 5 customers by number of successful transactions' do
      FactoryBot.create_list(:transaction, 6, result: 'success', invoice_id: @invoices[0].id)
      FactoryBot.create_list(:transaction, 4, result: 'success', invoice_id: @invoices[1].id)

      visit admin_index_path

      expect(page).to have_content("Top Customers")

      within("#top-customers") do
        expect(page).to have_content(Customer.top_customers.first.first_name)
        expect(page).to have_content(Customer.top_customers.first.last_name)
        expect(page).to have_content(Customer.top_customers.first.purchases)
        expect(page).to have_content(Customer.top_customers.second.first_name)
        expect(page).to have_content(Customer.top_customers.second.last_name)
        expect(page).to have_content(Customer.top_customers.second.purchases)

        expect(Customer.top_customers.first.first_name).to appear_before(Customer.top_customers.second.first_name)
      end
    end
  end

  describe 'incomplete invoices' do
    it 'shows the incomplete invoices with links to their invoice admin show page' do
      FactoryBot.create_list(:invoice_with_invoice_item, 1, invoice_item_status: 0)
      FactoryBot.create_list(:invoice_with_invoice_item, 2, invoice_item_status: 1)
      invoice_1 = Invoice.incomplete.first
      invoice_2 = Invoice.incomplete.second
      invoice_3 = Invoice.incomplete.third

      visit admin_index_path
      
      within("#incomplete-invoices") do
        expect(page).to have_link(invoice_1.id.to_s, href: admin_invoice_path(invoice_1))
        expect(page).to have_link(invoice_2.id.to_s, href: admin_invoice_path(invoice_2))
        expect(page).to have_link(invoice_3.id.to_s, href: admin_invoice_path(invoice_3))
      end
    end

    it 'shows invoice created_at and is sorted oldest to newest' do
      invoice_1 = FactoryBot.create(:invoice_with_invoice_item, invoice_item_status: 0, created_at: (Time.new(1950, 1, 1)))
      invoice_2 = FactoryBot.create(:invoice_with_invoice_item, invoice_item_status: 1, created_at: (Time.new(2050, 1, 1)))
      invoice_3 = FactoryBot.create(:invoice_with_invoice_item, invoice_item_status: 1, created_at: (Time.new(2000, 1, 1)))

      visit admin_index_path

      within("#incomplete-invoices") do
        expect(page).to have_content(invoice_1.created)
        expect(page).to have_content(invoice_2.created)
        expect(page).to have_content(invoice_3.created)

        expect(invoice_1.id.to_s).to appear_before(invoice_3.id.to_s)
        expect(invoice_3.id.to_s).to appear_before(invoice_2.id.to_s)
      end
    end
  end
end
