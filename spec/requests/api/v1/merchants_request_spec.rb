require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    merchant = merchant[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq("merchant")

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)

    merchant = merchant[:attributes]

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)
  end

  it "can create a new merchant" do
    merchant_params = ({
                    name: 'Jose Lopez'
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)
    created_merchant = Merchant.last

    expect(response).to be_successful

    expect(created_merchant.name).to eq(merchant_params[:name])
  end
end
