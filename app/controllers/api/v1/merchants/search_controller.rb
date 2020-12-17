module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def index
          attribute = params.keys.first
          render json: MerchantSerializer.new(Merchant.find_all_merchant(attribute, params[attribute]))
        end

        def show
          attribute = params.keys.first
          render json: MerchantSerializer.new(Merchant.find_merchant(attribute, params[attribute]))
        end

        def most_revenue
          render json: MerchantSerializer.new(Merchant.merchants_revenue(params[:quantity]))
        end

        def most_items
          render json: MerchantSerializer.new(Merchant.most_item_sold(params[:quantity]))
        end
      end
    end
  end
end
