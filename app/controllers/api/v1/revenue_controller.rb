module Api
  module V1
    class RevenueController < ApplicationController
      def index
        a = Merchant.revenue_range(params[:start], params[:end])
        require "pry"; binding.pry
      end
    end
  end
end
