require 'rails_helper'

RSpec.describe 'admin merchant new page' do
  before :each do 
    visit new_admin_merchant_path 
  end

  it 'allows user to create a new merchant with default status of disabled' do
    expect(page).to have_field(:name)
    expect(page).to have_field(:status)

    fill_in :name, with: 'Cinco'
    click_button 'Create Merchant'

    expect(current_path).to eq(admin_merchants_path)
    within('div#disabled') do
      expect(page).to have_content('Cinco')
    end
  end

  it 'allows the user to specify a status on creation' do
    fill_in :name, with: 'Cinco'
    fill_in :status, with: '1'
    click_button 'Create Merchant'

    expect(current_path).to eq(admin_merchants_path)
    within('div#enabled') do
      expect(page).to have_content('Cinco')
    end
  end
end