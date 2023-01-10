require 'rails_helper'

RSpec.describe 'admin invoices index' do
  describe 'story 32' do
    it 'shows all invoice ids in the system' do
      @invoices = FactoryBot.create_list(:invoice, 4)
      
      visit admin_invoices_path

      expect(page).to have_link("@invoices[0].id", href: admin_invoice_path(@invoices[0]))
      expect(page).to have_link("@invoices[1].id", href: admin_invoice_path(@invoices[1]))
      expect(page).to have_link("@invoices[2].id", href: admin_invoice_path(@invoices[2]))
      expect(page).to have_link("@invoices[3].id", href: admin_invoice_path(@invoices[3]))
    end
  end
end