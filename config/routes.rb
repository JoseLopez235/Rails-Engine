Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get "/find", to: "search#show"
        get "/find_all", to: "search#index"
        get "/most_revenue", to: "search#most_revenue"
        get "/:merchant_id/items", to: "items#index"
      end

      namespace :items do
        get "/find", to: "search#show"
        get "/find_all", to: "search#index"
        get '/:item_id/merchants', to: "merchants#index"
      end

      resources :merchants
      resources :items
    end
  end
end
