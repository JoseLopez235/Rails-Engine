module Api
  module V1
    class RevenueController < ApplicationController
      def index
        render json: RevenueSerializer.revenue(Merchant.revenue_range(params[:start], params[:end]))
      end
    end
  end
end
