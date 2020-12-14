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

  def update
    render json: Merchant.update(params[:id], merchant_params)
  end

  def destroy
    render json: Merchant.delete(params[:id])
  end

  def merchant_items
    merchant = Merchant.find(params[:merchant_id])
    items = merchant.all_items
    render json: ItemSerializer.format_items(items)
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
