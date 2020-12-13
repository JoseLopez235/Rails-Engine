class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all
    render json: MerchantSerializer.format_merchants(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.merchant_details(merchant)
  end

  def create
    render json: Merchant.create(merchant_params)
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
