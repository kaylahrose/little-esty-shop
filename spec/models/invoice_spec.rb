require 'rails_helper'

RSpec.describe Invoice do
  describe "Relationships" do
    it {should belong_to :customer} 
    it {should have_many :transactions} 
    it {should have_many :invoice_items} 
    it {should have_many(:items).through(:invoice_items)} 
  end
end