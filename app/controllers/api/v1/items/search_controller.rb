module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def index
          attribute = params.keys.first
          render json: ItemSerializer.new(Item.find_all_item(attribute, params[attribute]))
        end

        def show
          attribute = params.keys.first
          render json: ItemSerializer.new(Item.find_item(attribute, params[attribute]))
        end
      end
    end
  end
end
