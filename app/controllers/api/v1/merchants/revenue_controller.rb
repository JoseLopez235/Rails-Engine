module Api
  module V1
    module Merchants
      class RevenueController < ApplicationController
        def show
          render json: RevenueSerializer.revenue(Merchant.revenue_for_merchant(params[:merchant_id]))
        end
      end
    end
  end
end
