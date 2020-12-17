require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  it "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    item = item[:data]

    expect(item).to have_key(:id)
    expect(item[:id]).to eq("#{id}")

    expect(item).to have_key(:type)
    expect(item[:type]).to eq("item")

    expect(item).to have_key(:attributes)
    expect(item[:attributes]).to be_a(Hash)

    item = item[:attributes]

    expect(item).to have_key(:name)
    expect(item[:name]).to be_a(String)

    expect(item).to have_key(:description)
    expect(item[:description]).to be_a(String)

    expect(item).to have_key(:unit_price)
    expect(item[:unit_price]).to be_a(Float)

    expect(item).to have_key(:merchant_id)
    expect(item[:merchant_id]).to be_a(Integer)
  end

  it "can create a new item" do
    merchant = Merchant.create!(name: "Jose Lopez")
    item_params = ({
                    name: 'Car',
                    description: 'Red Car',
                    unit_price: 5.35,
                    merchant_id: merchant.id,
                  })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item_params)
    created_item = Item.last

    expect(response).to be_successful

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "can update an existing item" do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "Stuff Bear" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item_params)
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Stuff Bear")
  end

  it "can destroy an item" do
    item = create(:item)

    expect(Item.count).to eq(1)

    expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful

    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe "Relationships" do
    it "should return all merchants accoicated with the item" do
      item = create(:item)
      merchant = Merchant.find(item.merchant_id)

      get "/api/v1/items/#{item.id}/merchants"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)
      merchant = merchant[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end
  describe "Find Endpoints" do
    it "should find one item with the corresponding value" do
      item = create(:item, name: "Stuff Bear")
      create(:item, name: "Toy Car")
      attribute = "name"
      value = "bear"

      get "/api/v1/items/find?#{attribute}=#{value}"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(item.name).to eq(json[:data][:attributes][:name])
    end

    it "should find one item with a diffrent value" do
      create(:item, name: "Stuff Bear", description: "Fluffy and Cute")
      item = create(:item, name: "Toy Car", description: "Red Color with stripes")
      attribute = "description"
      value = "co"

      get "/api/v1/items/find?#{attribute}=#{value}"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(item.description).to eq(json[:data][:attributes][:description])
    end
    it "should find all merchants that correspond with the value" do
      create(:item, name: "Stuff Bear", description: "Fluffy and Cute")
      create(:item, name: "Toy Car", description: "Red Color with stripes")
      create(:item, name: "Stuff Lion", description: "Cute")
      create(:item, name: 'Princess Doll', description: "Cute and pretty")
      attribute = "description"
      value = "cute"

      get "/api/v1/items/find_all?#{attribute}=#{value}"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      items = json[:data]

      expect(items.count).to eq(3)

      expect(items[0][:attributes][:description]).to eq("Fluffy and Cute")

      expect(items[1][:attributes][:description]).to eq("Cute")

      expect(items[2][:attributes][:description]).to eq("Cute and pretty")
    end
  end
end
