class DiscountsController < ApplicationController
    def index 
        @merchant = Merchant.find(params[:merchant_id])

        @discounts = Discount.all
    end
    def new 
        @merchant = Merchant.find(params[:merchant_id])

    end
    def create 
        Discount.create!(percentage: params[:percentage].to_f, quantity_threshold: params[:quantity_threshold].to_i, merchant_id: params[:merchant_id])
        redirect_to "/merchant/#{params[:merchant_id]}/discounts"
    end
end