Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get "/find", to: "search#show"
        get "/find_all", to: "search#index"
        get "/most_revenue", to: "search#most_revenue"
        get "/most_items", to: "search#most_items"
        get "/:merchant_id/items", to: "items#index"
        get "/:merchant_id/revenue", to: "revenue#show"
      end

      namespace :items do
        get "/find", to: "search#show"
        get "/find_all", to: "search#index"
        get '/:item_id/merchants', to: "merchants#index"
      end

      resources :revenue, only: [:index]
      resources :merchants
      resources :items
    end
  end
end
