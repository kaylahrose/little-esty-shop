class DiscountsController < ApplicationController
    def index 
        @merchant = Merchant.find(params[:merchant_id])

        @discounts = Discount.all
    end
    def new 
        @merchant = Merchant.find(params[:merchant_id])

    end
    def show 
        @merchant = Merchant.find(params[:merchant_id])
        @discount = Discount.find(params[:id])
    end
    def create 
        Discount.create!(percentage: params[:percentage].to_f, quantity_threshold: params[:quantity_threshold].to_i, merchant_id: params[:merchant_id])
        redirect_to "/merchant/#{params[:merchant_id]}/discounts"
    end
    def destroy
        discount = Discount.find(params[:id])
        discount.destroy
        redirect_to "/merchant/#{params[:merchant_id]}/discounts"
    end
    def edit  
        @merchant = Merchant.find(params[:merchant_id])
        @discount = Discount.find(params[:id])
    end
    def update 
        @discount = Discount.find(params[:id])
        @discount.update(quantity_threshold: params[:quantity_threshold].to_i, percentage: params[:percentage].to_f)
        redirect_to "/merchant/#{params[:merchant_id]}/discounts/#{@discount.id}"
    end
end