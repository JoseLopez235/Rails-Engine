FactoryBot.define do
  factory :item do
    name { Faker::Camera.model}
    description { "Nikon Camera" }
    unit_price { 1.5 }
    merchant
  end
end
