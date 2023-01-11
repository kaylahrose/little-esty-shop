class Admin::MerchantsController < ApplicationController
  def new
  end

  def create
    merchant = Merchant.new(merchant_permit_params)
    if merchant.save
      redirect_to admin_merchants_path
    else
      redirect_to new_admin_merchant_path
      flash[:alert] = "error: #{error_message(merchant.errors)}"
    end
  end

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    if merchant.update(merchant_params)
      flash[:alert] = "Successfully updated"
      if params[:merchant][:name]
        redirect_to admin_merchant_path(merchant)
      else
        redirect_to admin_merchants_path
      end
    else
      redirect_to edit_admin_merchant_path(merchant)
      flash[:alert] = "Update failed"
    end
  end

  private

  def merchant_permit_params
    if params[:status].empty?
      params.permit(:name)
    else
      params.permit(:name, :status)
    end
  end

  def merchant_params
    params.require(:merchant).permit(:name, :status)
  end
end